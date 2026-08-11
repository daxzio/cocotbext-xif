import enum


class XifMode(enum.IntFlag):
    UMODE = 0b00
    SMODE = 0b01
    MMODE = 0b11
    RESERVED = 0b10
