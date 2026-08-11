from .bus import Bus


class XifBus(Bus):
    _signals = [
        "issue_valid",
        "issue_ready",
        "issue_req_instr",
        "issue_req_mode",
        "issue_req_id",
        "issue_req_rs_0",
        "issue_req_rs_1",
        "issue_req_rs_valid",
        "issue_resp_accept",
        "issue_resp_writeback",
        "issue_resp_dualwrite",
        "issue_resp_dualread",
        "issue_resp_loadstore",
        "issue_resp_exc",
        "mem_valid",
        "mem_ready",
        "mem_req_id",
        "mem_req_addr",
        "mem_req_mode",
        "mem_req_we",
        "mem_req_size",
        "mem_req_be",
        "mem_req_wdata",
        "mem_req_last",
        "mem_resp_exc",
        "mem_resp_exccode",
        "mem_result_valid",
        "mem_result_id",
        "mem_result_rdata",
        "mem_result_err",
        "commit_valid",
        "commit_id",
        "commit_kill",
        "result_valid",
        "result_ready",
        "result_id",
        "result_data",
        "result_rd",
        "result_we",
        "result_exc",
        "result_exccode",
    ]
    _optional_signals = [
        "issue_req_rs_2",
        "issue_req_ecs",
        "issue_req_ecs_valid",
        "mem_resp_dbg",
        "mem_result_dbg",
        "compressed_valid",
        "compressed_req",
    ]

    ISSUE_SIGNALS = (
        "issue_valid",
        "issue_ready",
        "issue_req_instr",
        "issue_req_mode",
        "issue_req_id",
        "issue_req_rs_0",
        "issue_req_rs_1",
        "issue_req_rs_2",
        "issue_req_rs_valid",
        "issue_resp_accept",
        "issue_resp_writeback",
        "issue_resp_dualwrite",
        "issue_resp_dualread",
        "issue_resp_loadstore",
        "issue_resp_exc",
        "issue_req_ecs",
        "issue_req_ecs_valid",
    )

    MEM_SIGNALS = (
        "mem_valid",
        "mem_ready",
        "mem_req_id",
        "mem_req_addr",
        "mem_req_mode",
        "mem_req_we",
        "mem_req_size",
        "mem_req_be",
        "mem_req_wdata",
        "mem_req_last",
        "mem_resp_exc",
        "mem_resp_exccode",
        "mem_result_valid",
        "mem_result_id",
        "mem_result_rdata",
        "mem_result_err",
        "mem_resp_dbg",
        "mem_result_dbg",
    )

    COMMIT_SIGNALS = ("commit_valid", "commit_id", "commit_kill")

    RESULT_SIGNALS = (
        "result_valid",
        "result_ready",
        "result_id",
        "result_data",
        "result_rd",
        "result_we",
        "result_exc",
        "result_exccode",
    )

    def __init__(
        self, entity=None, prefix=None, signals=None, optional_signals=None, **kwargs
    ):
        if signals is None:
            signals = self._signals
        if optional_signals is None:
            optional_signals = self._optional_signals
        super().__init__(
            entity, prefix, signals, optional_signals=optional_signals, **kwargs
        )

    @classmethod
    def from_entity(cls, entity, **kwargs):
        return cls(entity, **kwargs)

    @classmethod
    def from_prefix(cls, entity, prefix, **kwargs):
        return cls(entity, prefix, **kwargs)

    @property
    def has_rs_2(self) -> bool:
        return hasattr(self, "issue_req_rs_2")

    @property
    def xlen(self) -> int:
        return len(self.issue_req_rs_0)

    @property
    def id_width(self) -> int:
        return len(self.issue_req_id)

    @property
    def rs_valid_width(self) -> int:
        return len(self.issue_req_rs_valid)

    @property
    def rs_count(self) -> int:
        if self.has_rs_2:
            return max(3, self.rs_valid_width)
        return max(2, self.rs_valid_width)

    @property
    def mem_data_width(self) -> int:
        return len(self.mem_req_wdata)

    @property
    def mem_addr_width(self) -> int:
        return len(self.mem_req_addr)

    @property
    def mem_be_width(self) -> int:
        return len(self.mem_req_be)
