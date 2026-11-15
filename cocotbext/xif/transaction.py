"""
XIF transaction records and ID allocation.
"""

from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass

from .constants import XifMode


@dataclass
class XifInsn:
    """Instruction issue request (host -> coprocessor)."""

    instr: int
    rs: Sequence[int] = (0, 0, 0)
    rs_valid: int | None = None
    mode: XifMode = XifMode.MMODE
    id: int = 0
    expected: int | None = None
    check_we: bool = True
    committed: bool = False
    accepted: bool = False


@dataclass
class XifResult:
    """Result channel transaction (coprocessor -> host)."""

    id: int
    data: int
    rd: int = 0
    we: bool = False
    exc: bool = False
    exccode: int = 0


@dataclass
class XifMemReq:
    """Memory channel request (coprocessor -> host)."""

    id: int
    addr: int
    mode: XifMode
    we: bool
    size: int
    be: int
    wdata: int
    last: bool = True


@dataclass
class XifMemResult:
    """Memory channel result (host -> coprocessor)."""

    id: int
    rdata: int = 0
    err: bool = False


class IdAllocator:
    """Monotonic XIF transaction ID allocator with wrap."""

    def __init__(self, id_width: int) -> None:
        self.id_width = id_width
        self.id_mask = (1 << id_width) - 1 if id_width else 0
        self._next = 1
        self.in_flight: set[int] = set()

    def alloc(self) -> int:
        if self.id_width == 0:
            txn_id = 0
        else:
            txn_id = self._next
            self._next = (self._next + 1) & self.id_mask
            if self._next == 0:
                self._next = 1
        self.in_flight.add(txn_id)
        return txn_id

    def release(self, txn_id: int) -> None:
        self.in_flight.discard(txn_id)

    def clear(self) -> None:
        self.in_flight.clear()
