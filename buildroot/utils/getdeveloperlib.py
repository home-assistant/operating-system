from __future__ import print_function
from io import open
import os
import re
import glob
import subprocess
import sys
import unittest

brpath = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))

#
# Patch parsing functions
#

FIND_INFRA_IN_PATCH = re.compile(r"^\+\$\(eval \$\((host-)?([^-]*)-package\)\)$")


def analyze_patch(patch):
    """Parse one patch and return the list of files modified, added or
    removed by the patch."""
    files = set()
    infras = set()
    for line in patch:
        # If the patch is adding a package, find which infra it is
        m = FIND_INFRA_IN_PATCH.match(line)
        if m:
            infras.add(m.group(2))
        if not line.startswith("+++ "):
            continue
        line.strip()
        fname = line[line.find("/") + 1:].strip()
        if fname == "dev/null":
            continue
        files.add(fname)
    return (files, infras)


FIND_INFRA_IN_MK = re.compile(r"^\$\(eval \$\((host-)?([^-]*)-package\)\)$")


def fname_get_package_infra(fname):
    """Checks whether the file name passed as argument is a Buildroot .mk
    file describing a package, and find the infrastructure it's using."""
    if not fname.endswith(".mk"):
        return None

    if not os.path.exists(fname):
        return None

    with open(fname, "r") as f:
        for line in f:
            line = line.strip()
            m = FIND_INFRA_IN_MK.match(line)
            if m:
                return m.group(2)
    return None


def analyze_patches(patches):
    """Parse a list of patches and returns the list of files modified,
    added or removed by the patches, as well as the list of package
    infrastructures used by those patches (if any)"""
    allfiles = set()
    allinfras = set()
    for patch in patches:
        (files, infras) = analyze_patch(patch)
        allfiles = allfiles | files
        allinfras = allinfras | infras
    return (allfiles, allinfras)


#
# Unit-test parsing functions
#

def get_all_test_cases(suite):
    """Generate all test-cases from a given test-suite.
    :return: (test.module, test.name)"""
    if issubclass(type(suite), unittest.TestSuite):
        for test in suite:
            for res in get_all_test_cases(test):
                yield res
    else:
        yield (suite.__module__, suite.__class__.__name__)


def list_unittests():
    """Use the unittest module to retreive all test cases from a given
    directory"""
    loader = unittest.TestLoader()
    suite = loader.discover(os.path.join(brpath, "support", "testing"))
    tests = {}
    for module, test in get_all_test_cases(suite):
        module_path = os.path.join("support", "testing", *module.split('.'))
        tests.setdefault(module_path, []).append('%s.%s' % (module, test))
    return tests


unittests = {}


#
# DEVELOPERS file parsing functions
#

class Developer:
    def __init__(self, name, files):
        self.name = name
        self.files = files
        self.packages = parse_developer_packages(files)
        self.architectures = parse_developer_architectures(files)
        self.infras = parse_developer_infras(files)
        self.runtime_tests = parse_developer_runtime_tests(files)
        self.defconfigs = parse_developer_defconfigs(files)

    def hasfile(self, f):
        for fs in self.files:
            if f.startswith(fs):
                return True
        return False

    def __repr__(self):
        name = '\'' + self.name.split(' <')[0][:20] + '\''
        things = []
        if len(self.files):
            things.append('{} files'.format(len(self.files)))
        if len(self.packages):
            things.append('{} pkgs'.format(len(self.packages)))
        if len(self.architectures):
            things.append('{} archs'.format(len(self.architectures)))
        if len(self.infras):
            things.append('{} infras'.format(len(self.infras)))
        if len(self.runtime_tests):
            things.append('{} tests'.format(len(self.runtime_tests)))
        if len(self.defconfigs):
            things.append('{} defconfigs'.format(len(self.defconfigs)))
        if things:
            return 'Developer <{} ({})>'.format(name, ', '.join(things))
        else:
            return 'Developer <' + name + '>'


def parse_developer_packages(fnames):
    """Given a list of file patterns, travel through the Buildroot source
    tree to find which packages are implemented by those file
    patterns, and return a list of those packages."""
    packages = set()
    for fname in fnames:
        for root, dirs, files in os.walk(os.path.join(brpath, fname)):
            for f in files:
                path = os.path.join(root, f)
                if fname_get_package_infra(path):
                    pkg = os.path.splitext(f)[0]
                    packages.add(pkg)
    return packages


def parse_arches_from_config_in(fname):
    """Given a path to an arch/Config.in.* file, parse it to get the list
    of BR2_ARCH values for this architecture."""
    arches = set()
    with open(fname, "r") as f:
        parsing_arches = False
        for line in f:
            line = line.strip()
            if line == "config BR2_ARCH":
                parsing_arches = True
                continue
            if parsing_arches:
                m = re.match(r"^\s*default \"([^\"]*)\".*", line)
                if m:
                    arches.add(m.group(1))
                else:
                    parsing_arches = False
    return arches


def parse_developer_architectures(fnames):
    """Given a list of file names, find the ones starting by
    'arch/Config.in.', and use that to determine the architecture a
    developer is working on."""
    arches = set()
    for fname in fnames:
        if not re.match(r"^.*/arch/Config\.in\..*$", fname):
            continue
        arches = arches | parse_arches_from_config_in(fname)
    return arches


def parse_developer_infras(fnames):
    infras = set()
    for fname in fnames:
        m = re.match(r"^package/pkg-([^.]*).mk$", fname)
        if m:
            infras.add(m.group(1))
    return infras


def parse_developer_defconfigs(fnames):
    """Given a list of file names, returns the config names
    corresponding to defconfigs."""
    return {os.path.basename(fname[:-10])
            for fname in fnames
            if fname.endswith('_defconfig')}


def parse_developer_runtime_tests(fnames):
    """Given a list of file names, returns the runtime tests
    corresponding to the file."""
    all_files = []
    # List all files recursively
    for fname in fnames:
        if os.path.isdir(fname):
            for root, _dirs, files in os.walk(os.path.join(brpath, fname)):
                all_files += [os.path.join(root, f) for f in files]
        else:
            all_files.append(fname)

    # Get all runtime tests
    runtimes = set()
    for f in all_files:
        name = os.path.splitext(f)[0]
        if name in unittests:
            runtimes |= set(unittests[name])
    return runtimes


def parse_developers():
    """Parse the DEVELOPERS file and return a list of Developer objects."""
    developers = []
    linen = 0
    global unittests
    unittests = list_unittests()
    developers_fname = os.path.join(brpath, 'DEVELOPERS')
    with open(developers_fname, mode='r', encoding='utf_8') as f:
        files = []
        name = None
        for line in f:
            line = line.strip()
            if line.startswith("#"):
                continue
            elif line.startswith("N:"):
                if name is not None or len(files) != 0:
                    print("Syntax error in DEVELOPERS file, line %d" % linen,
                          file=sys.stderr)
                name = line[2:].strip()
            elif line.startswith("F:"):
                fname = line[2:].strip()
                dev_files = glob.glob(os.path.join(brpath, fname))
                if len(dev_files) == 0:
                    print("WARNING: '%s' doesn't match any file" % fname,
                          file=sys.stderr)
                for f in dev_files:
                    dev_file = os.path.relpath(f, brpath)
                    dev_file = dev_file.replace(os.sep, '/')  # force unix sep
                    files.append(dev_file)
            elif line == "":
                if not name:
                    continue
                developers.append(Developer(name, files))
                files = []
                name = None
            else:
                print("Syntax error in DEVELOPERS file, line %d: '%s'" % (linen, line),
                      file=sys.stderr)
                return None
            linen += 1
    # handle last developer
    if name is not None:
        developers.append(Developer(name, files))
    return developers


def check_developers(developers, basepath=None):
    """Look at the list of files versioned in Buildroot, and returns the
    list of files that are not handled by any developer"""
    if basepath is None:
        basepath = os.getcwd()
    cmd = ["git", "--git-dir", os.path.join(basepath, ".git"), "ls-files"]
    files = subprocess.check_output(cmd).strip().split("\n")
    unhandled_files = []
    for f in files:
        handled = False
        for d in developers:
            if d.hasfile(os.path.join(basepath, f)):
                handled = True
                break
        if not handled:
            unhandled_files.append(f)
    return unhandled_files
