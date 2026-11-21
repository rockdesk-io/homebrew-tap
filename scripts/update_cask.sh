#!/usr/bin/env bash
set -euo pipefail

# Auto-update Casks/rockdesk.rb from https://rockdesk.io/rockd-latest.json
JSON_URL="https://rockdesk.io/rockd-latest.json"
CASK_FILE="$(cd "$(dirname "$0")/.." && pwd)/Casks/rockdesk.rb"

echo "Fetching latest metadata from ${JSON_URL}..."
META="$(curl -fsSL "${JSON_URL}")"

VERSION="$(python3 -c 'import sys,json; print(json.loads(sys.stdin.read())["version"])' <<< "${META}")"
ARM_URL="$(python3 -c 'import sys,json; print(json.loads(sys.stdin.read())["files"]["macos"])' <<< "${META}")"
X86_URL="$(python3 -c 'import sys,json; print(json.loads(sys.stdin.read())["files"]["macos-x86_64"])' <<< "${META}")"

echo "Latest version: ${VERSION}"
echo "Computing SHA256 for arm64 (${ARM_URL})..."
ARM_SHA="$(curl -fsSL "${ARM_URL}" | sha256sum | awk '{print $1}')"
echo "Computing SHA256 for x86_64 (${X86_URL})..."
X86_SHA="$(curl -fsSL "${X86_URL}" | sha256sum | awk '{print $1}')"

python3 - "${CASK_FILE}" "${VERSION}" "${ARM_SHA}" "${X86_SHA}" <<'PY'
import re, sys
path, ver, arm_sha, x86_sha = sys.argv[1:]
with open(path, 'r', encoding='utf-8') as f:
    src = f.read()

src = re.sub(r'version "[^"]+"', f'version "{ver}"', src, count=1)
src = re.sub(r'arm:\s+"[0-9a-f]{64}"', f'arm:   "{arm_sha}"', src, count=1)
src = re.sub(r'intel:\s+"[0-9a-f]{64}"', f'intel: "{x86_sha}"', src, count=1)

with open(path, 'w', encoding='utf-8') as f:
    f.write(src)
print(f"Updated {path} -> v{ver} (arm64={arm_sha[:12]}..., x86_64={x86_sha[:12]}...)")
PY

