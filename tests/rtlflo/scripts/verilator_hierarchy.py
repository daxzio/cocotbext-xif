#!/usr/bin/env python3
"""
Print RTL hierarchy from Verilator --json-only output: instance path, module type, source file.

Usage:
  verilator_hierarchy.py <tree.json> <tree.meta.json> --top <top_module>

Output (tab-separated): hierarchy_path  instance_name  module_type  source_file
"""

import argparse
import json
import sys


def load_json(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def collect_modules(node, modules_by_addr):
    """Recursively collect all MODULE nodes and map addr -> module info."""
    if not isinstance(node, dict):
        return
    if node.get("type") == "MODULE":
        addr = node.get("addr")
        if addr:
            modules_by_addr[addr] = {
                "name": node.get("name", ""),
                "loc": node.get("loc", ""),
                "stmtsp": node.get("stmtsp", []),
            }
    for key, val in node.items():
        if key in ("stmtsp", "inlinesp", "modulesp", "modulep", "typesp"):
            if isinstance(val, list):
                for item in val:
                    collect_modules(item, modules_by_addr)
        elif isinstance(val, (dict, list)):
            collect_modules(val, modules_by_addr)


def loc_to_file(loc, files_meta):
    """Parse loc 'fileId,line:col,line:col' and return source path from meta."""
    if not loc:
        return ""
    parts = loc.split(",", 1)
    file_id = parts[0].strip()
    path = files_meta.get(file_id, {})
    return path.get("realpath") or path.get("filename") or file_id


def walk_hierarchy(modules_by_addr, files_meta, mod_addr, path_prefix, rows):
    """Emit one row per instance: path, instance_name, module_type, source_file."""
    mod = modules_by_addr.get(mod_addr)
    if not mod:
        return
    mod_name = mod["name"]
    mod_file = loc_to_file(mod["loc"], files_meta)
    # Skip internal / const-pool modules
    if mod_name.startswith("@"):
        return
    for st in mod.get("stmtsp", []):
        if st.get("type") != "CELL":
            continue
        inst_name = st.get("name", "")
        cell_modp = st.get("modp")
        if not cell_modp:
            continue
        cell_mod = modules_by_addr.get(cell_modp)
        if not cell_mod:
            continue
        cell_type = cell_mod.get("name", "")
        if cell_type.startswith("@"):
            continue
        cell_file = loc_to_file(st.get("loc") or cell_mod.get("loc", ""), files_meta)
        full_path = f"{path_prefix}/{inst_name}" if path_prefix else inst_name
        rows.append((full_path, inst_name, cell_type, cell_file))
        # Recurse into submodule
        walk_hierarchy(modules_by_addr, files_meta, cell_modp, full_path, rows)


def main():
    ap = argparse.ArgumentParser(description="Print Verilator hierarchy: path, instance, module, file")
    ap.add_argument("tree_json", help="V*.tree.json from verilator --json-only")
    ap.add_argument("meta_json", help="V*.tree.meta.json")
    ap.add_argument("--top", required=True, help="Top module name")
    args = ap.parse_args()

    tree = load_json(args.tree_json)
    meta = load_json(args.meta_json)
    files_meta = meta.get("files", {})

    modules_by_addr = {}
    collect_modules(tree, modules_by_addr)

    # Find top module by name (prefer level 1 / first in modulesp)
    top_addr = None
    for addr, m in modules_by_addr.items():
        if m["name"] == args.top:
            top_addr = addr
            break
    if not top_addr:
        print(f"Top module '{args.top}' not found.", file=sys.stderr)
        sys.exit(1)

    rows = []
    top_mod = modules_by_addr[top_addr]
    top_file = loc_to_file(top_mod["loc"], files_meta)
    rows.append(("", args.top, args.top, top_file))
    walk_hierarchy(modules_by_addr, files_meta, top_addr, "", rows)

    # Header
    print("PATH\tINSTANCE\tMODULE\tSOURCE_FILE")
    for path, inst, mod, src in rows:
        print(f"{path}\t{inst}\t{mod}\t{src}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
