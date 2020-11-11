#!/usr/bin/env python3

# This scripts check that all lines present in the defconfig are
# still present in the .config

import sys


def main():
    if not (len(sys.argv) == 3):
        print("Error: incorrect number of arguments")
        print("""Usage: check-dotconfig <configfile> <defconfig>""")
        sys.exit(1)

    configfile = sys.argv[1]
    defconfig = sys.argv[2]

    # strip() to get rid of trailing \n
    with open(configfile) as configf:
        configlines = [l.strip() for l in configf.readlines()]

    defconfiglines = []
    with open(defconfig) as defconfigf:
        # strip() to get rid of trailing \n
        for line in (line.strip() for line in defconfigf.readlines()):
            if line.startswith("BR2_"):
                defconfiglines.append(line)
            elif line.startswith('# BR2_') and line.endswith(' is not set'):
                defconfiglines.append(line)

    # Check that all the defconfig lines are still present
    missing = [line for line in defconfiglines if line not in configlines]

    if missing:
        print("WARN: defconfig {} can't be used:".format(defconfig))
        for m in missing:
            print("      Missing: {}".format(m))
        sys.exit(1)


if __name__ == "__main__":
    main()
