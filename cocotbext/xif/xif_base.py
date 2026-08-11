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

import logging
import datetime
from random import randint, seed

from .version import __version__


class XifBase:
    def __init__(self, bus, clock, name="monitor", seednum=None) -> None:
        self.name = name
        self.bus = bus
        self.clock = clock
        if bus._name:
            self.log = logging.getLogger(f"cocotb.xif_{name}.{bus._name}")
        else:
            self.log = logging.getLogger(f"cocotb.xif_{name}")
        self.log.setLevel(logging.INFO)
        self.log.info(f"XIF {self.name}")
        self.log.info(f"cocotbext-xif version {__version__}")
        self.log.info(f"Copyright (c) 2024-{datetime.datetime.now().year} Daxzio")
        self.log.info("https://github.com/daxzio/cocotbext-xif")

        # self.total_devices = len(self.bus.psel)
        # self.multi_device = False
        # if self.total_devices > 1:
        #     self.multi_device = True
        # self.byte_size = 8
        # self.address_width = len(self.bus.paddr)
        self.id_width = len(self.bus.issue_req_id)
        # self.wbytes = int(self.wwidth / 8)
        self.id_mask = 2**self.id_width - 1
        # self.byte_lanes = self.wwidth // self.byte_size
        # self.strb_mask = 2**self.byte_lanes - 1
        # self.rwidth = []
        # self.rbytes = []
        # self.rdata_mask = []
        # for i in range(self.total_devices):
        #     self.rwidth.append(int(len(self.bus.prdata) / self.total_devices))
        #     self.rbytes.append(int(self.rwidth[i] / 8))
        #     self.rdata_mask.append(2 ** self.rwidth[i] - 1)

        # self.penable_present = hasattr(self.bus, "penable")
        # self.pstrb_present = hasattr(self.bus, "pstrb")
        # self.pprot_present = hasattr(self.bus, "pprot")
        # self.pslverr_present = hasattr(self.bus, "pslverr")
        # if self.pstrb_present:
        #     assert self.byte_lanes == len(self.bus.pstrb)
        # assert self.byte_lanes * self.byte_size == self.wwidth

        self.log.info(f"XIF {self.name} configuration:")
        # self.log.info(f"  Address width: {self.address_width} bits")
        # self.log.info(f"  Byte size: {self.byte_size} bits")
        # self.log.info(f"  Data width: {self.wwidth} bits ({self.byte_lanes} bytes)")

        self.log.debug("XIF signals:")
        for sig in sorted(
            list(set().union(self.bus._signals, self.bus._optional_signals))
        ):
            #print(sig)
            try:
                if hasattr(self.bus, sig):
                    self.log.debug(f"  {sig} width: {len(getattr(self.bus, sig))} bits")
                else:
                    self.log.debug(f"  {sig}: not present")
            except TypeError:
                raise Exception(f"  {sig}: error, signal is not present")

        # self.backpressure = False
        # if seednum is not None:
        #     self.base_seed = seednum
        # else:
        #     self.base_seed = randint(0, 0xFFFFFF)
        # seed(self.base_seed)
        # self.log.debug(f"Seed is set to {self.base_seed}")

    # @property
    # def delay(self):
    #     if self.backpressure:
    #         if 0 == randint(0, 0x3):
    #             return randint(0, 0x8)
    #         else:
    #             return 0
    #     else:
    #         return 0

    def enable_logging(self):
        self.log.setLevel(logging.DEBUG)

    def disable_logging(self):
        self.log.setLevel(logging.INFO)

    def enable_backpressure(self, seednum=None):
        self.backpressure = True
        if seednum is not None:
            self.base_seed = seednum

    def disable_backpressure(self):
        self.backpressure = False
