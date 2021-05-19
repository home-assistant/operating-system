#!/usr/bin/env python

# Copyright (C) 2009 by Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
# Copyright (C) 2020 by Gregory CLEMENT <gregory.clement@bootlin.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

import datetime
import os
import requests  # URL checking
import distutils.version
import time
import gzip
import sys
import operator

try:
    import ijson
    # backend is a module in < 2.5, a string in >= 2.5
    if 'python' in getattr(ijson.backend, '__name__', ijson.backend):
        try:
            import ijson.backends.yajl2_cffi as ijson
        except ImportError:
            sys.stderr.write('Warning: Using slow ijson python backend\n')
except ImportError:
    sys.stderr.write("You need ijson to parse NVD for CVE check\n")
    exit(1)

sys.path.append('utils/')

NVD_START_YEAR = 2002
NVD_JSON_VERSION = "1.1"
NVD_BASE_URL = "https://nvd.nist.gov/feeds/json/cve/" + NVD_JSON_VERSION

ops = {
    '>=': operator.ge,
    '>': operator.gt,
    '<=': operator.le,
    '<': operator.lt,
    '=': operator.eq
}


# Check if two CPE IDs match each other
def cpe_matches(cpe1, cpe2):
    cpe1_elems = cpe1.split(":")
    cpe2_elems = cpe2.split(":")

    remains = filter(lambda x: x[0] not in ["*", "-"] and x[1] not in ["*", "-"] and x[0] != x[1],
                     zip(cpe1_elems, cpe2_elems))
    return len(list(remains)) == 0


def cpe_product(cpe):
    return cpe.split(':')[4]


def cpe_version(cpe):
    return cpe.split(':')[5]


class CVE:
    """An accessor class for CVE Items in NVD files"""
    CVE_AFFECTS = 1
    CVE_DOESNT_AFFECT = 2
    CVE_UNKNOWN = 3

    def __init__(self, nvd_cve):
        """Initialize a CVE from its NVD JSON representation"""
        self.nvd_cve = nvd_cve

    @staticmethod
    def download_nvd_year(nvd_path, year):
        metaf = "nvdcve-%s-%s.meta" % (NVD_JSON_VERSION, year)
        path_metaf = os.path.join(nvd_path, metaf)
        jsonf_gz = "nvdcve-%s-%s.json.gz" % (NVD_JSON_VERSION, year)
        path_jsonf_gz = os.path.join(nvd_path, jsonf_gz)

        # If the database file is less than a day old, we assume the NVD data
        # locally available is recent enough.
        if os.path.exists(path_jsonf_gz) and os.stat(path_jsonf_gz).st_mtime >= time.time() - 86400:
            return path_jsonf_gz

        # If not, we download the meta file
        url = "%s/%s" % (NVD_BASE_URL, metaf)
        print("Getting %s" % url)
        page_meta = requests.get(url)
        page_meta.raise_for_status()

        # If the meta file already existed, we compare the existing
        # one with the data newly downloaded. If they are different,
        # we need to re-download the database.
        # If the database does not exist locally, we need to redownload it in
        # any case.
        if os.path.exists(path_metaf) and os.path.exists(path_jsonf_gz):
            meta_known = open(path_metaf, "r").read()
            if page_meta.text == meta_known:
                return path_jsonf_gz

        # Grab the compressed JSON NVD, and write files to disk
        url = "%s/%s" % (NVD_BASE_URL, jsonf_gz)
        print("Getting %s" % url)
        page_json = requests.get(url)
        page_json.raise_for_status()
        open(path_jsonf_gz, "wb").write(page_json.content)
        open(path_metaf, "w").write(page_meta.text)
        return path_jsonf_gz

    @classmethod
    def read_nvd_dir(cls, nvd_dir):
        """
        Iterate over all the CVEs contained in NIST Vulnerability Database
        feeds since NVD_START_YEAR. If the files are missing or outdated in
        nvd_dir, a fresh copy will be downloaded, and kept in .json.gz
        """
        for year in range(NVD_START_YEAR, datetime.datetime.now().year + 1):
            filename = CVE.download_nvd_year(nvd_dir, year)
            try:
                content = ijson.items(gzip.GzipFile(filename), 'CVE_Items.item')
            except:  # noqa: E722
                print("ERROR: cannot read %s. Please remove the file then rerun this script" % filename)
                raise
            for cve in content:
                yield cls(cve)

    def each_product(self):
        """Iterate over each product section of this cve"""
        for vendor in self.nvd_cve['cve']['affects']['vendor']['vendor_data']:
            for product in vendor['product']['product_data']:
                yield product

    def parse_node(self, node):
        """
        Parse the node inside the configurations section to extract the
        cpe information usefull to know if a product is affected by
        the CVE. Actually only the product name and the version
        descriptor are needed, but we also provide the vendor name.
        """

        # The node containing the cpe entries matching the CVE can also
        # contain sub-nodes, so we need to manage it.
        for child in node.get('children', ()):
            for parsed_node in self.parse_node(child):
                yield parsed_node

        for cpe in node.get('cpe_match', ()):
            if not cpe['vulnerable']:
                return
            product = cpe_product(cpe['cpe23Uri'])
            version = cpe_version(cpe['cpe23Uri'])
            # ignore when product is '-', which means N/A
            if product == '-':
                return
            op_start = ''
            op_end = ''
            v_start = ''
            v_end = ''

            if version != '*' and version != '-':
                # Version is defined, this is a '=' match
                op_start = '='
                v_start = version
            else:
                # Parse start version, end version and operators
                if 'versionStartIncluding' in cpe:
                    op_start = '>='
                    v_start = cpe['versionStartIncluding']

                if 'versionStartExcluding' in cpe:
                    op_start = '>'
                    v_start = cpe['versionStartExcluding']

                if 'versionEndIncluding' in cpe:
                    op_end = '<='
                    v_end = cpe['versionEndIncluding']

                if 'versionEndExcluding' in cpe:
                    op_end = '<'
                    v_end = cpe['versionEndExcluding']

            yield {
                'id': cpe['cpe23Uri'],
                'v_start': v_start,
                'op_start': op_start,
                'v_end': v_end,
                'op_end': op_end
            }

    def each_cpe(self):
        for node in self.nvd_cve['configurations']['nodes']:
            for cpe in self.parse_node(node):
                yield cpe

    @property
    def identifier(self):
        """The CVE unique identifier"""
        return self.nvd_cve['cve']['CVE_data_meta']['ID']

    @property
    def affected_products(self):
        """The set of CPE products referred by this CVE definition"""
        return set(cpe_product(p['id']) for p in self.each_cpe())

    def affects(self, name, version, cve_ignore_list, cpeid=None):
        """
        True if the Buildroot Package object passed as argument is affected
        by this CVE.
        """
        if self.identifier in cve_ignore_list:
            return self.CVE_DOESNT_AFFECT

        pkg_version = distutils.version.LooseVersion(version)
        if not hasattr(pkg_version, "version"):
            print("Cannot parse package '%s' version '%s'" % (name, version))
            pkg_version = None

        # if we don't have a cpeid, build one based on name and version
        if not cpeid:
            cpeid = "cpe:2.3:*:*:%s:%s:*:*:*:*:*:*:*" % (name, version)
        # if we have a cpeid, use its version instead of the package
        # version, as they might be different due to
        # <pkg>_CPE_ID_VERSION
        else:
            pkg_version = distutils.version.LooseVersion(cpe_version(cpeid))

        for cpe in self.each_cpe():
            if not cpe_matches(cpe['id'], cpeid):
                continue
            if not cpe['v_start'] and not cpe['v_end']:
                return self.CVE_AFFECTS
            if not pkg_version:
                continue

            if cpe['v_start']:
                try:
                    cve_affected_version = distutils.version.LooseVersion(cpe['v_start'])
                    inrange = ops.get(cpe['op_start'])(pkg_version, cve_affected_version)
                except TypeError:
                    return self.CVE_UNKNOWN

                # current package version is before v_start, so we're
                # not affected by the CVE
                if not inrange:
                    continue

            if cpe['v_end']:
                try:
                    cve_affected_version = distutils.version.LooseVersion(cpe['v_end'])
                    inrange = ops.get(cpe['op_end'])(pkg_version, cve_affected_version)
                except TypeError:
                    return self.CVE_UNKNOWN

                # current package version is after v_end, so we're
                # not affected by the CVE
                if not inrange:
                    continue

            # We're in the version range affected by this CVE
            return self.CVE_AFFECTS

        return self.CVE_DOESNT_AFFECT
