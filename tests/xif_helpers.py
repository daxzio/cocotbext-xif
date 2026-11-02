"""Shared helpers for cocotb XIF testbenches."""


def init_reset_before_host(dut, reset_name: str = "rst_ni", active_level: int = 0) -> None:
    """Drive reset to its active level before constructing ``XifHost``.

    Icarus leaves undriven inputs as ``Z`` at time 0; ``XifHost`` background
    coroutines read reset immediately. Verilator may also start with ``X``.
    The library resolves ``X``/``Z`` via ``resolve_x_int``, but tests should
    still drive reset explicitly before creating the host.
    """
    getattr(dut, reset_name).value = active_level
