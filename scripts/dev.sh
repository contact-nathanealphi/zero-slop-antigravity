#!/usr/bin/env bash
# Rebuild generated files, then validate. Run after editing core/ or skills/.
set -euo pipefail
cd "$(dirname "$0")/.."
bash scripts/build-master-prompt.sh
bash scripts/gen-checksums.sh
bash scripts/validate.sh
