#!/usr/bin/env python3

import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element, SubElement
import gzip
import os
import requests
import time
from xml.dom import minidom

VALID_REFS = ['VENDOR', 'VERSION', 'CHANGE_LOG', 'PRODUCT', 'PROJECT', 'ADVISORY']

CPEDB_URL = "https://static.nvd.nist.gov/feeds/xml/cpe/dictionary/official-cpe-dictionary_v2.3.xml.gz"

ns = {
    '': 'http://cpe.mitre.org/dictionary/2.0',
    'cpe-23': 'http://scap.nist.gov/schema/cpe-extension/2.3',
    'xml': 'http://www.w3.org/XML/1998/namespace'
}


class CPE:
    def __init__(self, cpe_str, titles, refs):
        self.cpe_str = cpe_str
        self.titles = titles
        self.references = refs
        self.cpe_cur_ver = "".join(self.cpe_str.split(":")[5:6])

    def update_xml_dict(self):
        ET.register_namespace('', 'http://cpe.mitre.org/dictionary/2.0')
        cpes = Element('cpe-list')
        cpes.set('xmlns:cpe-23', "http://scap.nist.gov/schema/cpe-extension/2.3")
        cpes.set('xmlns:ns6', "http://scap.nist.gov/schema/scap-core/0.1")
        cpes.set('xmlns:scap-core', "http://scap.nist.gov/schema/scap-core/0.3")
        cpes.set('xmlns:config', "http://scap.nist.gov/schema/configuration/0.1")
        cpes.set('xmlns:xsi', "http://www.w3.org/2001/XMLSchema-instance")
        cpes.set('xmlns:meta', "http://scap.nist.gov/schema/cpe-dictionary-metadata/0.2")
        cpes.set('xsi:schemaLocation', " ".join(["http://scap.nist.gov/schema/cpe-extension/2.3",
                                                 "https://scap.nist.gov/schema/cpe/2.3/cpe-dictionary-extension_2.3.xsd",
                                                 "http://cpe.mitre.org/dictionary/2.0",
                                                 "https://scap.nist.gov/schema/cpe/2.3/cpe-dictionary_2.3.xsd",
                                                 "http://scap.nist.gov/schema/cpe-dictionary-metadata/0.2",
                                                 "https://scap.nist.gov/schema/cpe/2.1/cpe-dictionary-metadata_0.2.xsd",
                                                 "http://scap.nist.gov/schema/scap-core/0.3",
                                                 "https://scap.nist.gov/schema/nvd/scap-core_0.3.xsd",
                                                 "http://scap.nist.gov/schema/configuration/0.1",
                                                 "https://scap.nist.gov/schema/nvd/configuration_0.1.xsd",
                                                 "http://scap.nist.gov/schema/scap-core/0.1",
                                                 "https://scap.nist.gov/schema/nvd/scap-core_0.1.xsd"]))
        item = SubElement(cpes, 'cpe-item')
        cpe_short_name = CPE.short_name(self.cpe_str)
        cpe_new_ver = CPE.version_update(self.cpe_str)

        item.set('name', 'cpe:/' + cpe_short_name)
        self.titles[0].text.replace(self.cpe_cur_ver, cpe_new_ver)
        for title in self.titles:
            item.append(title)
        if self.references:
            item.append(self.references)
        cpe23item = SubElement(item, 'cpe-23:cpe23-item')
        cpe23item.set('name', self.cpe_str)

        # Generate the XML as a string
        xmlstr = ET.tostring(cpes)

        # And use minidom to pretty print the XML
        return minidom.parseString(xmlstr).toprettyxml(encoding="utf-8").decode("utf-8")

    @staticmethod
    def version(cpe):
        return cpe.split(":")[5]

    @staticmethod
    def product(cpe):
        return cpe.split(":")[4]

    @staticmethod
    def short_name(cpe):
        return ":".join(cpe.split(":")[2:6])

    @staticmethod
    def version_update(cpe):
        return ":".join(cpe.split(":")[5:6])

    @staticmethod
    def no_version(cpe):
        return ":".join(cpe.split(":")[:5])


class CPEDB:
    def __init__(self, nvd_path):
        self.all_cpes = dict()
        self.all_cpes_no_version = dict()
        self.nvd_path = nvd_path

    def get_xml_dict(self):
        print("CPE: Setting up NIST dictionary")
        if not os.path.exists(os.path.join(self.nvd_path, "cpe")):
            os.makedirs(os.path.join(self.nvd_path, "cpe"))

        cpe_dict_local = os.path.join(self.nvd_path, "cpe", os.path.basename(CPEDB_URL))
        if not os.path.exists(cpe_dict_local) or os.stat(cpe_dict_local).st_mtime < time.time() - 86400:
            print("CPE: Fetching xml manifest from [" + CPEDB_URL + "]")
            cpe_dict = requests.get(CPEDB_URL)
            open(cpe_dict_local, "wb").write(cpe_dict.content)

        print("CPE: Unzipping xml manifest...")
        nist_cpe_file = gzip.GzipFile(fileobj=open(cpe_dict_local, 'rb'))
        print("CPE: Converting xml manifest to dict...")
        tree = ET.parse(nist_cpe_file)
        all_cpedb = tree.getroot()
        self.parse_dict(all_cpedb)

    def parse_dict(self, all_cpedb):
        # Cycle through the dict and build two dict to be used for custom
        # lookups of partial and complete CPE objects
        # The objects are then used to create new proposed XML updates if
        # if is determined one is required
        # Out of the different language titles, select English
        for cpe in all_cpedb.findall(".//{http://cpe.mitre.org/dictionary/2.0}cpe-item"):
            cpe_titles = []
            for title in cpe.findall('.//{http://cpe.mitre.org/dictionary/2.0}title[@xml:lang="en-US"]', ns):
                title.tail = None
                cpe_titles.append(title)

            # Some older CPE don't include references, if they do, make
            # sure we handle the case of one ref needing to be packed
            # in a list
            cpe_ref = cpe.find(".//{http://cpe.mitre.org/dictionary/2.0}references")
            if cpe_ref:
                for ref in cpe_ref.findall(".//{http://cpe.mitre.org/dictionary/2.0}reference"):
                    ref.tail = None
                    ref.text = ref.text.upper()
                    if ref.text not in VALID_REFS:
                        ref.text = ref.text + "-- UPDATE this entry, here are some examples and just one word should be used -- " + ' '.join(VALID_REFS) # noqa E501
                cpe_ref.tail = None
                cpe_ref.text = None

            cpe_str = cpe.find(".//{http://scap.nist.gov/schema/cpe-extension/2.3}cpe23-item").get('name')
            item = CPE(cpe_str, cpe_titles, cpe_ref)
            cpe_str_no_version = CPE.no_version(cpe_str)
            # This dict must have a unique key for every CPE version
            # which allows matching to the specific obj data of that
            # NIST dict entry
            self.all_cpes.update({cpe_str: item})
            # This dict has one entry for every CPE (w/o version) to allow
            # partial match (no valid version) check (the obj is saved and
            # used as seed for suggested xml updates. By updating the same
            # non-version'd entry, it assumes the last update here is the
            # latest version in the NIST dict)
            self.all_cpes_no_version.update({cpe_str_no_version: item})

    def find_partial(self, cpe_str):
        cpe_str_no_version = CPE.no_version(cpe_str)
        if cpe_str_no_version in self.all_cpes_no_version:
            return cpe_str_no_version

    def find_partial_obj(self, cpe_str):
        cpe_str_no_version = CPE.no_version(cpe_str)
        if cpe_str_no_version in self.all_cpes_no_version:
            return self.all_cpes_no_version[cpe_str_no_version]

    def find_partial_latest_version(self, cpe_str_partial):
        cpe_obj = self.find_partial_obj(cpe_str_partial)
        return cpe_obj.cpe_cur_ver

    def find(self, cpe_str):
        if self.find_partial(cpe_str):
            if cpe_str in self.all_cpes:
                return cpe_str

    def gen_update_xml(self, cpe_str):
        cpe = self.find_partial_obj(cpe_str)
        return cpe.update_xml_dict()
