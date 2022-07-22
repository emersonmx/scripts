#!/usr/bin/env python3


from __future__ import annotations

import re
import subprocess
from dataclasses import dataclass
from functools import lru_cache, partial
from itertools import cycle

run = partial(subprocess.run, check=True)


class CurrentMonitorNotFound(Exception):
    pass


class InvalidMousePosition(Exception):
    pass


class NextMonitorNotFound(Exception):
    pass


@dataclass
class Monitor:
    label: str
    primary: bool
    x: int
    y: int
    width: int
    height: int


@dataclass
class Position:
    x: int
    y: int


def log(msg: str) -> None:
    with open("/home/emerson-silva/output.log", "a") as f:
        f.write(f"{msg}\n")


def main() -> int:
    log("1")
    next_monitor = get_next_monitor()
    log("2")
    swap_to_monitor(next_monitor)
    log("3")
    return 0


def get_next_monitor() -> Monitor:
    monitors = get_available_monitors()
    current_monitor = get_current_monitor()

    monitor_iterator = cycle(monitors)
    for monitor in monitor_iterator:
        if monitor == current_monitor:
            return next(monitor_iterator)
    raise NextMonitorNotFound()


@lru_cache(maxsize=None)
def get_available_monitors() -> list[Monitor]:
    pattern = re.compile(
        r"^(.*) connected ?(primary)? (\d+)x(\d+)\+(\d+)\+(\d+).*",
        re.MULTILINE,
    )
    monitors = []
    for match in pattern.findall(xrandr_output()):
        label, primary, width, height, x, y = match
        monitors.append(
            Monitor(
                label=label,
                primary=bool(primary),
                x=int(x),
                y=int(y),
                width=int(width),
                height=int(height),
            )
        )
    return monitors


@lru_cache(maxsize=None)
def xrandr_output() -> str:
    output = run(["xrandr", "--current"], capture_output=True)
    return output.stdout.decode()  # type: ignore


@lru_cache(maxsize=None)
def get_current_monitor() -> Monitor:
    monitors = get_available_monitors()
    mouse_position = get_mouse_position()
    for monitor in monitors:
        mx, my = mouse_position.x, mouse_position.y
        x, y, w, h = monitor.x, monitor.y, monitor.width, monitor.height
        if x <= mx <= (x + w) and y <= my <= (y + h):
            return monitor
    raise CurrentMonitorNotFound()


def get_mouse_position() -> Position:
    pattern = re.compile(r"^x:(\d+) y:(\d+) .*")
    if match := pattern.match(get_xdotool_mouse_location_output()):
        x, y = match.groups()
        return Position(x=int(x), y=int(y))
    raise InvalidMousePosition()


@lru_cache(maxsize=None)
def get_xdotool_mouse_location_output() -> str:
    output = run(["xdotool", "getmouselocation"], capture_output=True)
    return output.stdout.decode()  # type: ignore


def swap_to_monitor(monitor: Monitor) -> None:
    stylus_device = get_stylus_device()
    rect = f"{monitor.width}x{monitor.height}+{monitor.x}+{monitor.y}"
    run(["xsetwacom", "set", stylus_device, "MapToOutput", rect])
    log(f"Swapped to monitor: {monitor.label}")  # noqa


def get_stylus_device() -> str:
    return "Wacom Intuos S 2 Pen stylus"


if __name__ == "__main__":
    raise SystemExit(main())
