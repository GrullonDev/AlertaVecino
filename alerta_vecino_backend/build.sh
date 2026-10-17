#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "🧹 Cleaning AppleDouble files…"
find . -name "._*" -delete

echo "🔨 Building with dart_frog…"
dart_frog build

echo "🧹 Cleaning AppleDouble files from build…"
find build -name "._*" -delete

echo "🔧 Fixing route mount order (specific before parent)…"
python3 << 'PYEOF'
import pathlib, re

p = pathlib.Path('build/bin/server.dart')
src = p.read_text()

# Swap pairs: put /x/<id> before /x for visitors/passes and panic
pairs = [
    ('visitors/passes', 'visitors/passes/<id>'),
    ('panic', 'panic/<id>'),
]

lines = src.split('\n')
for parent_seg, child_seg in pairs:
    parent_i = child_i = None
    for i, line in enumerate(lines):
        if f"mount('/api/v1/{parent_seg}'," in line and '<id>' not in line:
            parent_i = i
        if f"mount('/api/v1/{child_seg}'," in line:
            child_i = i
    if parent_i is not None and child_i is not None and parent_i < child_i:
        lines[parent_i], lines[child_i] = lines[child_i], lines[parent_i]

p.write_text('\n'.join(lines))
print('  Done.')
PYEOF

echo "✅ Build complete. Run with: dart build/bin/server.dart"
