#!/usr/bin/env python

import argparse
from collections import namedtuple
import re

from kconfiglib import Kconfig


# Can be either "CONFIG_OPTION=(y|m|n)" or "# CONFIG_OPTION is not set"
regex = re.compile(
    r"^(CONFIG_(?P<option_set>[A-Z0-9_]+)=(?P<value>[mny])"
    r"|# CONFIG_(?P<option_unset>[A-Z0-9_]+) is not set)$"
)

# use namedtuple as a lightweight representation of fragment-defined options
OptionValue = namedtuple("OptionValue", ["option", "value", "file", "line"])


def parse_fragment(
    filename: str, strip_path_prefix: str = None
) -> dict[str, OptionValue]:
    """
    Parse Buildroot Kconfig fragment and return dict of OptionValue objects.
    """
    options: dict[str, OptionValue] = {}

    with open(filename) as f:
        if strip_path_prefix and filename.startswith(strip_path_prefix):
            filename = filename[len(strip_path_prefix) :]

        for line_number, line in enumerate(f, 1):
            if matches := re.match(regex, line):
                if matches["option_unset"]:
                    value = OptionValue(
                        matches["option_unset"], None, filename, line_number
                    )
                    options.update({matches.group("option_unset"): value})
                else:
                    value = OptionValue(
                        matches["option_set"], matches["value"], filename, line_number
                    )
                    options.update({matches.group("option_set"): value})

    return options


def _format_message(
    message: str, file: str, line: int, github_format: bool = False
) -> str:
    """
    Format message with source file and line number.
    """
    if github_format:
        return f"::warning file={file},line={line}::{message}"
    return f"{message} (defined in {file}:{line})"


def compare_configs(
    expected_options: dict[str, OptionValue],
    kconfig: Kconfig,
    github_format: bool = False,
) -> None:
    """
    Compare dictionary of expected options with actual Kconfig representation.
    """
    for option, spec in expected_options.items():
        if option not in kconfig.syms:
            print(
                _format_message(
                    f"{option}={spec.value} not found",
                    file=spec.file,
                    line=spec.line,
                    github_format=github_format,
                )
            )
        elif (val := kconfig.syms[option].str_value) != spec.value:
            if spec.value is None and val == "n":
                continue
            print(
                _format_message(
                    f"{option}={spec.value} requested, actual = {val}",
                    file=spec.file,
                    line=spec.line,
                    github_format=github_format,
                )
            )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--src-kconfig", help="Path to top-level Kconfig file", required=True
    )
    parser.add_argument(
        "--actual-config",
        help="Path to config with actual config values (.config)",
        required=True,
    )
    parser.add_argument(
        "--github-format",
        action="store_true",
        help="Use Github Workflow commands output format",
    )
    parser.add_argument(
        "-s",
        "--strip-path-prefix",
        help="Path prefix to strip in the output from config fragment paths",
    )
    parser.add_argument("fragments", nargs="+", help="Paths to source config fragments")

    args = parser.parse_args()

    expected_options: dict[str, OptionValue] = {}

    for f in args.fragments:
        expected_options.update(
            parse_fragment(f, strip_path_prefix=args.strip_path_prefix)
        )

    kconfig = Kconfig(args.src_kconfig, warn_to_stderr=False)
    kconfig.load_config(args.actual_config)

    compare_configs(expected_options, kconfig, github_format=args.github_format)


if __name__ == "__main__":
    main()
