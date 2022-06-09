#!/system/bin/sh
set -e
set -o errexit

modDir=${0%/*}
. "$modDir/lib/common.sh"

logIt "modDir: $modDir"
logIt "env
$(env)"

mkdir --parents "$modDir/system/etc/security/cacerts"

chown -R root:root "$modDir/system/etc/security/cacerts"
chmod -R ugo-rwx,ugo+rX,u+w "$modDir/system/etc/security/cacerts"
chcon -R u:object_r:system_security_cacerts_file:s0 "$modDir/system/etc/security/cacerts"
set_perm_recursive "$modDir/system/etc/security/cacerts" root root 644
touch -t 202102032028 "$modDir/system/etc/security/cacerts/*"
