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

from .address_space import (
    AddressSpace,
    MemoryInterface,
    MemoryRegion,
    PeripheralRegion,
    Pool,
    Region,
    SparseMemoryRegion,
    Window,
    WindowPool,
)
from .constants import XifMode
from .encoders import (
    BitrevEncoder,
    FaddSEncoder,
    HorcruxEncoder,
    InsnEncoder,
    RvvConfigEncoder,
    vtype_encode,
)
from .memory import Memory
from .riscv import encode_i, encode_r, encode_r4
from .transaction import IdAllocator, XifInsn, XifMemReq, XifMemResult, XifResult
from .version import __version__
from .xif_bus import XifBus
from .xif_device import XifDevice
from .xif_host import XifHost
from .xif_monitor import XifMonitor

__all__ = [
    "AddressSpace",
    "BitrevEncoder",
    "FaddSEncoder",
    "HorcruxEncoder",
    "IdAllocator",
    "InsnEncoder",
    "Memory",
    "MemoryInterface",
    "MemoryRegion",
    "PeripheralRegion",
    "Pool",
    "Region",
    "RvvConfigEncoder",
    "SparseMemoryRegion",
    "Window",
    "WindowPool",
    "XifBus",
    "XifDevice",
    "XifHost",
    "XifInsn",
    "XifMemReq",
    "XifMemResult",
    "XifMode",
    "XifMonitor",
    "XifResult",
    "__version__",
    "encode_i",
    "encode_r",
    "encode_r4",
    "vtype_encode",
]
