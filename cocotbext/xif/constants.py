import enum


class XIFSlvErr(Exception):
    pass


class XIFPrivilegedErr(XIFSlvErr):
    pass


class XIFInstructionErr(XIFSlvErr):
    pass


# Protection bits
# PPROT
class XifProt(enum.IntFlag):
    PRIVILEGED = 0b001
    NONSECURE = 0b010
    INSTRUCTION = 0b100

# | Value | Mode     | Description                                                     |
# | ----- | -------- | --------------------------------------------------------------- |
# | 2'b11 | M-Mode   | Machine Mode (Highest privilege, firmware/bootloader)           |
# | 2'b01 | S-Mode   | Supervisor Mode (Operating System / Linux Kernel)               |
# | 2'b00 | U-Mode   | User Mode (Regular applications)                                |
# | 2'b10 | Reserved | Reserved (sometimes used for Hypervisor mode in other contexts) |
class XifMode(enum.IntFlag):
    UMODE = 0b00
    SMODE = 0b01
    MMODE = 0b11
    RESERVED = 0b10

# from typing import NamedTuple
# from cocotb.triggers import Event
# class ApbWriteCmd(NamedTuple):
#     address: int
#     data: bytes
#     prot: XifProt
#     event: Event
#
#
# class ApbReadCmd(NamedTuple):
#     address: int
#     prot: XifProt
#     event: Event
