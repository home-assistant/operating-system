#!/usr/bin/env python

"""
Byte compile all .py files from provided directories. This script is an
alternative implementation of compileall.compile_dir written with
cross-compilation in mind.
"""

from __future__ import print_function

import argparse
import os
import py_compile
import re
import sys


def compile_one(host_path, strip_root=None, verbose=False):
    """
    Compile a .py file into a .pyc file located next to it.

    :arg host_path:
        Absolute path to the file to compile on the host running the build.
    :arg strip_root:
        Prefix to remove from the original source paths encoded in compiled
        files.
    :arg verbose:
        Print compiled file paths.
    """
    if os.path.islink(host_path) or not os.path.isfile(host_path):
        return  # only compile real files

    if not re.match(r"^[_A-Za-z][_A-Za-z0-9]+\.py$",
                    os.path.basename(host_path)):
        return  # only compile "importable" python modules

    if strip_root is not None:
        # determine the runtime path of the file (i.e.: relative path to root
        # dir prepended with "/").
        runtime_path = os.path.join("/", os.path.relpath(host_path, strip_root))
    else:
        runtime_path = host_path

    if verbose:
        print("  PYC  {}".format(runtime_path))

    # will raise an error if the file cannot be compiled
    py_compile.compile(host_path, cfile=host_path + "c",
                       dfile=runtime_path, doraise=True)


def existing_dir_abs(arg):
    """
    argparse type callback that checks that argument is a directory and returns
    its absolute path.
    """
    if not os.path.isdir(arg):
        raise argparse.ArgumentTypeError('no such directory: {!r}'.format(arg))
    return os.path.abspath(arg)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dirs", metavar="DIR", nargs="+", type=existing_dir_abs,
                        help="Directory to recursively scan and compile")
    parser.add_argument("--strip-root", metavar="ROOT", type=existing_dir_abs,
                        help="""
                        Prefix to remove from the original source paths encoded
                        in compiled files
                        """)
    parser.add_argument("--verbose", action="store_true",
                        help="Print compiled files")

    args = parser.parse_args()

    try:
        for d in args.dirs:
            if args.strip_root and ".." in os.path.relpath(d, args.strip_root):
                parser.error("DIR: not inside ROOT dir: {!r}".format(d))
            for parent, _, files in os.walk(d):
                for f in files:
                    compile_one(os.path.join(parent, f), args.strip_root,
                                args.verbose)

    except Exception as e:
        print("error: {}".format(e))
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
