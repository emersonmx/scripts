#!/usr/bin/env python

import re
import subprocess
from functools import partial

run = partial(subprocess.run, capture_output=True, check=True)


def main() -> int:
    PATTERN = r"^Core .*:\s+\+(\d+)\.\d+°C.*$"
    result = run(["sensors", "coretemp-isa-*"])
    output: str = result.stdout.decode("utf-8")
    sum_temps = 0
    count = 0
    for line in output.splitlines():
        match = re.match(PATTERN, line)
        if match:
            sum_temps += int(match.group(1))
            count += 1
    avg = sum_temps / count if count > 0 else 0

    print(f"Average CPU temperature: {avg:.2f}°C")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
