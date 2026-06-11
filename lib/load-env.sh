# Source rudolph/.env (if present) so helpers pick up CURSOR_API_KEY and
# friends without those secrets living in the shell profile. Never prints values.
# shellcheck shell=bash
_RUDOLPH_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$_RUDOLPH_ROOT/.env" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$_RUDOLPH_ROOT/.env"
  set +a
fi
