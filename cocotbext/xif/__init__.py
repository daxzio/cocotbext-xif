"""

Copyright (c) 2024-2025 Daxzio

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

from .version import __version__

from .xif_bus import XifBus
from .xif_host import XifHost
from .xif_monitor import XifMonitor
from .xif_device import XifDevice

from .constants import XifMode

from .transaction import XifInsn, XifResult, XifMemReq, XifMemResult, IdAllocator

from .riscv import encode_r, encode_r4, encode_i
from .encoders import (
    InsnEncoder,
    BitrevEncoder,
    FaddSEncoder,
    RvvConfigEncoder,
    HorcruxEncoder,
    vtype_encode,
)

from .memory import Memory
from .address_space import MemoryInterface, Window, WindowPool
from .address_space import Region, MemoryRegion, SparseMemoryRegion, PeripheralRegion
from .address_space import AddressSpace, Pool

__all__ = [
    "__version__",
    "XifBus",
    "XifHost",
    "XifMonitor",
    "XifDevice",
    "XifMode",
    "XifInsn",
    "XifResult",
    "XifMemReq",
    "XifMemResult",
    "IdAllocator",
    "encode_r",
    "encode_r4",
    "encode_i",
    "InsnEncoder",
    "BitrevEncoder",
    "FaddSEncoder",
    "RvvConfigEncoder",
    "HorcruxEncoder",
    "vtype_encode",
    "Memory",
    "MemoryInterface",
    "Window",
    "WindowPool",
    "Region",
    "MemoryRegion",
    "SparseMemoryRegion",
    "PeripheralRegion",
    "AddressSpace",
    "Pool",
]
