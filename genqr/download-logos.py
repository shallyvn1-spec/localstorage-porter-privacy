#!/usr/bin/env python3
"""Download 64 unique logo images from the provided HTML URLs to ./logos/.
    Run: python download-logos.py
    Pure standard library; multi-threaded and includes official VietQR fallbacks.
"""
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from urllib.request import Request, urlopen
import json, io, sys

BASE = Path(__file__).resolve().parent
ROOT = BASE / "logos"
ROOT.mkdir(exist_ok=True)
ROWS = json.loads((BASE / "logos-manifest.json").read_text(encoding="utf-8"))["logos"]

def fetch_one(entry):
    dest = ROOT / f"{entry['id']}.png"
    if dest.exists() and dest.stat().st_size > 32:
        return (True, entry["names"], "skip")
    for url in [entry["source"], entry.get("fallback")]:
        if not url or not url.startswith("https://"):
            continue
        try:
            req = Request(url, headers={"User-Agent": "Mozilla/5.0", "Accept": "image/png,image/jpeg,image/*;q=0.9"})
            with urlopen(req, timeout=12) as reply:
                data = reply.read(2 * 1024 * 1024 + 1)
                if len(data) > 2 * 1024 * 1024: raise ValueError("image too large")
                if data.startswith(b"\x89PNG\r\n\x1a\n"):
                    dest.write_bytes(data)
                    return (True, entry["names"], url)
                # Python version avoids wrongly labeling a JPEG/WebP as PNG.
                # Downloaded JPEG/WebP is instead not saved and triggers the next fallback.
                raise ValueError("image is not PNG")
        except Exception:
            continue
    return (False, entry["names"], "")

with ThreadPoolExecutor(max_workers=10) as pool:
    results = [f.result() for f in as_completed([pool.submit(fetch_one, item) for item in ROWS])]

ok = sum(x[0] for x in results)
print(f"Logo PNG da tai: {ok}/{len(ROWS)}")
failed = [", ".join(names) for success,names,_ in results if not success]
if failed:
    (BASE / "failed-logos.txt").write_text("\n".join(failed), encoding="utf-8")
    print(f"Khong tai duoc {len(failed)} logo. Xem failed-logos.txt")
print("Tren GitHub, upload ca thu muc logos/ va index.html vao genqr/.")
