#!/usr/bin/env python3
"""Post-process sv2v output so Icarus can elaborate it.

- Strip DPI-C export/task/function blocks (Icarus has no DPI)
- Unroll single-statement for (lane = 0; lane < NrLanes; ...) loops so
  Icarus sees constant indexed part-select bases (NrLanes=2)
"""
from __future__ import annotations

import re
import sys

# Must match DEFINES NR_LANES in the Makefile.
NR_LANES = 2


def strip_dpi(text: str) -> str:
    out: list[str] = []
    skip_until: str | None = None
    skip_export = False
    for line in text.splitlines(True):
        if skip_until:
            if skip_until in line:
                skip_until = None
            continue
        if 'export "DPI-C"' in line:
            skip_export = True
            continue
        if skip_export:
            s = line.lstrip()
            if s.startswith("task ") or s.startswith("function "):
                skip_until = "endtask" if s.startswith("task ") else "endfunction"
            skip_export = False
            continue
        out.append(line)
    return "".join(out)


# Only complete single-line statements (must end with ';'). Multi-line if/begin
# bodies are left alone — unrolling those would orphan the trailing statements.
_LANE_FOR = re.compile(
    r"^([ \t]*)for \(lane = 0; lane < NrLanes; lane = lane \+ 1\)\n"
    r"([ \t]+)(?!begin\b)([^\n]*;)$",
    re.MULTILINE,
)


def unroll_lane_for_loops(text: str, nr_lanes: int = NR_LANES) -> str:
    """Unroll single-statement NrLanes lane loops so widths become constant."""

    def repl(m: re.Match[str]) -> str:
        indent, body_indent, body = m.group(1), m.group(2), m.group(3)
        stmts = [
            f"{body_indent}{re.sub(r'\blane\b', str(lane), body)}"
            for lane in range(nr_lanes)
        ]
        return f"{indent}begin\n" + "\n".join(stmts) + f"\n{indent}end"

    return _LANE_FOR.sub(repl, text)


def fix(text: str) -> str:
    text = strip_dpi(text)
    text = unroll_lane_for_loops(text)
    return text


def main() -> None:
    if len(sys.argv) != 2:
        sys.stderr.write(f"Usage: {sys.argv[0]} file.v\n")
        sys.exit(1)
    path = sys.argv[1]
    with open(path) as f:
        text = f.read()
    with open(path, "w") as f:
        f.write(fix(text))


if __name__ == "__main__":
    main()
