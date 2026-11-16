"""

Copyright (c) 2024-2026 Daxzio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""

import datetime
import logging
from typing import Any

from .utils import resolve_x_int
from .version import __version__


class XifBase:
    def __init__(
        self,
        bus,
        clock,
        name: str = "monitor",
        reset: Any = None,
        reset_active_level: bool = False,
        **kwargs,
    ) -> None:
        log_quiet = kwargs.pop("log_quiet", False)

        self.name = name
        self.bus = bus
        self.clock = clock
        self.reset = reset
        self.reset_active_level = reset_active_level

        if bus._name:
            self.log = logging.getLogger(f"cocotb.xif_{name}.{bus._name}")
        else:
            self.log = logging.getLogger(f"cocotb.xif_{name}")
        self.log.setLevel(logging.WARNING if log_quiet else logging.INFO)

        self.id_width = bus.id_width
        self.id_mask = (1 << self.id_width) - 1 if self.id_width else 0
        self.xlen = bus.xlen
        self.x_mask = (1 << self.xlen) - 1 if self.xlen else 0
        self.rs_count = bus.rs_count
        self.rs_valid_width = bus.rs_valid_width
        self.rs_valid_mask = (1 << self.rs_valid_width) - 1 if self.rs_valid_width else 0
        self.mem_data_width = bus.mem_data_width
        self.mem_data_mask = (1 << self.mem_data_width) - 1 if self.mem_data_width else 0
        self.mem_be_width = bus.mem_be_width
        self.mem_addr_width = bus.mem_addr_width

        if not log_quiet:
            self.log.info(f"XIF {self.name}")
            self.log.info(f"cocotbext-xif version {__version__}")
            self.log.info(f"Copyright (c) 2024-{datetime.datetime.now().year} Daxzio")
            self.log.info("https://github.com/daxzio/cocotbext-xif")
            self.log.info(f"XIF {self.name} configuration:")
            self.log.info(f"  XLEN: {self.xlen} bits")
            self.log.info(f"  ID width: {self.id_width} bits")
            self.log.info(f"  RS count: {self.rs_count}")
            self.log.info(f"  Mem data width: {self.mem_data_width} bits")

        self.log.debug("XIF signals:")
        bus_cls = type(self.bus)
        for sig in sorted(
            set().union(bus_cls.SIGNAL_NAMES, bus_cls.OPTIONAL_SIGNAL_NAMES)
        ):
            if not hasattr(self.bus, sig):
                self.log.debug(f"  {sig}: not present")
                continue
            handle = getattr(self.bus, sig)
            if handle is None:
                self.log.debug(f"  {sig}: not present")
                continue
            try:
                self.log.debug(f"  {sig} width: {len(handle)} bits")
            except TypeError:
                self.log.debug(f"  {sig}: present (non-sized)")

    def enable_logging(self) -> None:
        """Per-transaction and configuration detail (logger level DEBUG)."""
        self.log.setLevel(logging.DEBUG)

    def disable_logging(self) -> None:
        """Default for passive monitor: warnings and errors only."""
        self.log.setLevel(logging.WARNING)

    def mask_x(self, value: int) -> int:
        return value & self.x_mask

    def default_rs_valid(self, rs_valid: int | None = None) -> int:
        if rs_valid is not None:
            return rs_valid & self.rs_valid_mask
        if self.rs_valid_width:
            return self.rs_valid_mask
        return 0

    def normalize_rs(self, rs) -> tuple[int, ...]:
        values = list(rs)
        while len(values) < self.rs_count:
            values.append(0)
        return tuple(self.mask_x(v) for v in values[: self.rs_count])

    async def _wait_reset_release(self) -> None:
        if self.reset is None:
            return
        from cocotb.triggers import FallingEdge, RisingEdge

        active = int(self.reset_active_level)
        release_edge = RisingEdge if not self.reset_active_level else FallingEdge
        while resolve_x_int(self.reset) == active:
            await release_edge(self.reset)
