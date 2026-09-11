#!/usr/bin/env python

import re
import csv
import subprocess
from functools import partial

run = partial(subprocess.run, capture_output=True, text=True)


def sensors(query: str | None = None) -> str:
    """Run sensors command and return the output."""

    try:
        if query:
            result = run(["sensors", query])
        else:
            result = run(["sensors"])
        if result.returncode != 0:
            raise RuntimeError(f"sensors failed with error: {result.stderr}")
        return result.stdout
    except FileNotFoundError:
        raise RuntimeError("sensors command not found. Is lm-sensors installed?")


def parse_sensors_cpu(output: str) -> list[list[str]]:
    PATTERN = r"^(.*):\s+\+(.*)\.\d+°C\s+\(high\s+=\s+\+(.*)°C,\s+crit\s+=\s+\+(.*)°C\)"

    data_table = []
    for line in output.splitlines():
        match = re.match(PATTERN, line)
        if not match:
            continue
        row = [match.group(1), match.group(2), match.group(3), match.group(4)]
        data_table.append(row)

    return data_table


def nvidia_smi(query: list[str] | None = None) -> list[list[str]]:
    """Run nvidia-smi command and return the output."""
    try:
        if query:
            result = run(
                [
                    "nvidia-smi",
                    "--query-gpu",
                    ",".join(query),
                    "--format",
                    "csv,noheader",
                ]
            )
        else:
            result = run(["nvidia-smi"])
        if result.returncode != 0:
            raise RuntimeError(f"nvidia-smi failed with error: {result.stderr}")
        output: str = result.stdout
        data = csv.reader(output.splitlines(), delimiter=",")
        data_table = [[item.strip() for item in row] for row in data]
        return data_table
    except FileNotFoundError:
        raise RuntimeError("nvidia-smi command not found. Is NVIDIA driver installed?")


def print_table(header: list[str], data: list[list[str]]) -> None:
    col_widths = [len(h) for h in header]
    for row in data:
        for i, item in enumerate(row):
            col_widths[i] = max(col_widths[i], len(item))

    header_row = " | ".join(h.ljust(col_widths[i]) for i, h in enumerate(header))
    print(header_row)
    print("-" * len(header_row))

    for row in data:
        data_row = " | ".join(item.ljust(col_widths[i]) for i, item in enumerate(row))
        print(data_row)


def main() -> int:
    print("CPU")
    output = sensors("coretemp-isa-*")
    header = ["Core", "Temp", "High", "Critical"]
    data = parse_sensors_cpu(output)
    print_table(header, data)

    print()

    print("GPU")
    header = [
        "Temp",
        "PState",
        "HW Slowdown",
        "Graphics Clock",
        "SM Clock",
        "Memory Clock",
        "Video Clock",
    ]

    data = nvidia_smi(
        [
            "temperature.gpu",
            "pstate",
            "clocks_event_reasons.hw_slowdown",
            "clocks.current.graphics",
            "clocks.current.sm",
            "clocks.current.memory",
            "clocks.current.video",
        ]
    )
    print_table(header, data)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
