#!/usr/bin/env bash
set -e
set -o errexit

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"

# Based on https://stackoverflow.com/a/46569793

hash=$(openssl x509 -inform PEM -subject_hash_old -in "$here/mitmproxy.pem" | head -1)
content="$(cat "$here/mitmproxy.pem")
$(openssl x509 -inform PEM -text -in "$here/mitmproxy.pem")"
echo "$content" >"$here/magisk-module-mitmproxy-cert/system/etc/security/cacerts/$hash.0"
