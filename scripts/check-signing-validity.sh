#!/usr/bin/env bash
# Fail the build if the signing certificate, or any CA certificate in its chain,
# expires within MIN_DAYS. Bundles signed now must stay verifiable across the
# whole support window, so we rotate proactively rather than ship a bundle that
# stops validating before the window ends. Run in CI before building.
#
# Usage: check-signing-validity.sh <signing-cert.pem> <keyring.pem> [min_days]
set -euo pipefail

CERT="${1:?usage: $0 <signing-cert.pem> <keyring.pem> [min_days]}"
KEYRING="${2:?usage: $0 <signing-cert.pem> <keyring.pem> [min_days]}"
MIN_DAYS="${3:-760}"

THRESHOLD=$(date -u -d "+${MIN_DAYS} days" +%s)
THRESHOLD_DATE=$(date -u -d "+${MIN_DAYS} days" +%Y-%m-%d)

fail() { echo "::error::$*"; exit 1; }
enddate()   { openssl x509 -in "$1" -noout -enddate | cut -d= -f2; }
subject()   { openssl x509 -in "$1" -noout -subject | sed 's/^subject=//'; }
too_soon()  { [ "$(date -u -d "$(enddate "$1")" +%s)" -lt "$THRESHOLD" ]; }

# 1) CA chain (most urgent: a CA rotation is a full migration). Walk the chain
# leaf -> intermediate -> root through the keyring, checking each CA cert. Only
# the chain the leaf actually uses is walked, so the deliberately-expiring old CA
# certs (kept in the keyring for downgrades) are ignored.
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
awk -v d="$tmp" '/-----BEGIN CERTIFICATE-----/{n++} {print > (d"/"n".pem")}' "$KEYRING"

# Issuer of $1 within the keyring, picked by signature (not just subject name) so
# same-subject certs - e.g. a future same-CN key rotation - are disambiguated.
find_issuer() {
  local cand ih
  ih=$(openssl x509 -in "$1" -noout -issuer_hash)
  for cand in "$tmp"/*.pem; do
    # Narrow by subject name, then confirm by signature (-partial_chain treats
    # the candidate as a standalone anchor, -no_check_time leaves expiry to us).
    # Only the real signer verifies, so same-subject siblings are disambiguated.
    [ "$(openssl x509 -in "$cand" -noout -subject_hash)" = "$ih" ] || continue
    openssl verify -partial_chain -no_check_time -CAfile "$cand" "$1" >/dev/null 2>&1 \
      && { printf '%s\n' "$cand"; return 0; }
  done
  return 1
}

cur="$CERT"; hops=0
while :; do
  [ "$(openssl x509 -in "$cur" -noout -subject_hash)" = \
    "$(openssl x509 -in "$cur" -noout -issuer_hash)" ] && break   # self-signed root
  next=$(find_issuer "$cur") || fail "Issuer of '$(subject "$cur")' not found in ${KEYRING} - the signing certificate does not chain to this keyring."
  if too_soon "$next"; then
    fail "CA certificate '$(subject "$next")' expires $(enddate "$next") (within ${MIN_DAYS} days, before ${THRESHOLD_DATE}). A new CA should be generated, the keyrings (buildroot-external/ota/*-ca.pem) updated, and the cross-signed intermediate added to the bundle."
  fi
  cur="$next"; hops=$((hops + 1))
  [ "$hops" -le 10 ] || fail "certificate chain too long (loop?)"
done

# 2) signing leaf
if too_soon "$CERT"; then
  fail "Signing certificate expires $(enddate "$CERT") (within ${MIN_DAYS} days, before ${THRESHOLD_DATE}). A new leaf certificate needs to be generated and the CI signing key updated."
fi

echo "Signing certificate and CA chain (in total $((hops + 1)) certificates) are valid for at least ${MIN_DAYS} days (past ${THRESHOLD_DATE})."
