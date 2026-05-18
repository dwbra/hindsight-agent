#!/usr/bin/env bash
# Stop hook. Surfaces an unread `worth_refactoring` review for the current HEAD
# back to the Claude Code session via stderr + exit 2.

set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

exec "$PLUGIN_ROOT/bin/run-with-node.sh" "$PLUGIN_ROOT/dist/surface.js"
