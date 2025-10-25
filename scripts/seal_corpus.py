#!/usr/bin/env python3
import argparse, hashlib, json, os, sys, time
from pathlib import Path

def file_hash(p: Path) -> str:
    return hashlib.sha3_256(p.read_bytes()).hexdigest()

def collect(paths):
    files=[]
    for base in paths:
        b=Path(base)
        if not b.exists(): continue
        if b.is_file(): files.append(b)
        else:
            for p in b.rglob("*"):
                if p.is_file(): files.append(p)
    # deterministic order
    return sorted(files, key=lambda x: x.as_posix())

def seal(files):
    entries=[]
    for f in files:
        entries.append({"path": f.as_posix(), "sha3_256": file_hash(f)})
    root_hasher = hashlib.sha3_256()
    for e in entries:
        root_hasher.update((e["path"]+":"+e["sha3_256"]).encode())
    return entries, root_hasher.hexdigest()

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--out")
    ap.add_argument("--verify", action="store_true", help="verify existing seal")
    ap.add_argument("paths", nargs="+")
    args=ap.parse_args()

    if args.verify:
        seal_file=Path(args.out)
        data=json.loads(seal_file.read_text())
        files=collect(args.paths)
        entries, root=seal(files)
        ok = (root==data["root_sha3_256"])
        print("VERIFY:", "OK" if ok else "MISMATCH")
        if not ok: sys.exit(1)
        sys.exit(0)

    files=collect(args.paths)
    entries, root=seal(files)
    out={
        "artifact":"vm-umbrella",
        "algo":"SHA3-256",
        "root_sha3_256": root,
        "entries": entries,
        "epoch": 1,
        "ts_iso": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    }
    Path(args.out).write_text(json.dumps(out, indent=2))
    print("Wrote", args.out, "root:", root)

if __name__=="__main__":
    main()
