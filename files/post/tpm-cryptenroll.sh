set -euo pipefail

# Enroll TPM2 unlock for all detected LUKS2 devices and ensure that every
# enrolled device has a corresponding crypttab entry.
#
# Assumptions:
# - All discovered crypto_LUKS devices should be unlocked automatically.
# - All LUKS devices use the same provisioning passphrase.
# - A TPM2 or vTPM2 device is present.
# - Existing crypttab mapper names and options must be preserved.

PCRS="${KS_TPM2_PCRS:-7}"
PASSFILE="/root/.luks-pass"
CRYPTTAB="/etc/crypttab"
TMP_CRYPTTAB=""

cleanup() {
    rm -f -- "${PASSFILE}"

    if [[ -n "${TMP_CRYPTTAB}" ]]; then
        rm -f -- "${TMP_CRYPTTAB}"
    fi
}

trap cleanup EXIT

umask 077
printf '%s' "${KS_LUKS_PASSPHRASE}" > "${PASSFILE}"

# Discover the actual block devices containing LUKS headers.
mapfile -t LUKS_DEVS < <(
    blkid -t TYPE=crypto_LUKS -o device | sort
)

if ((${#LUKS_DEVS[@]} == 0)); then
    printf 'No LUKS devices found, skipping TPM enrollment.\n'
    exit 0
fi

# Enroll the TPM2 token in every discovered LUKS device.
for dev in "${LUKS_DEVS[@]}"; do
    systemd-cryptenroll \
        --unlock-key-file="${PASSFILE}" \
        --tpm2-device=auto \
        --tpm2-pcrs="${PCRS}" \
        "${dev}"
done

# Create crypttab when Anaconda did not create one.
if [[ ! -e "${CRYPTTAB}" ]]; then
    install -m 0600 /dev/null "${CRYPTTAB}"
fi

TMP_CRYPTTAB="$(mktemp /etc/crypttab.XXXXXX)"

# Preserve all installer-generated entries and add the TPM2 options required
# by the installed system. Existing mapper names and source specifications are
# intentionally retained.
awk '
    BEGIN {
        OFS = "\t"
    }

    /^[[:space:]]*#/ || NF == 0 {
        print
        next
    }

    {
        opts = $4

        if (opts == "" || opts == "-") {
            opts = "tpm2-device=auto,tpm2-measure-pcr=yes"
        } else {
            if (opts !~ /(^|,)tpm2-device=/) {
                opts = opts ",tpm2-device=auto"
            }

            if (opts !~ /(^|,)tpm2-measure-pcr=/) {
                opts = opts ",tpm2-measure-pcr=yes"
            }
        }

        $4 = opts
        print
    }
' "${CRYPTTAB}" > "${TMP_CRYPTTAB}"

# Add entries for LUKS devices that Anaconda did not place in crypttab.
# A stable mapper name derived from the LUKS UUID is used for these devices.
for dev in "${LUKS_DEVS[@]}"; do
    uuid="$(cryptsetup luksUUID "${dev}")"

    if grep -Eq "UUID=${uuid}([[:space:]]|$)" "${TMP_CRYPTTAB}"; then
        continue
    fi

    printf '%s\tUUID=%s\tnone\t%s\n' \
        "luks-${uuid}" \
        "${uuid}" \
        "tpm2-device=auto,tpm2-measure-pcr=yes" \
        >> "${TMP_CRYPTTAB}"
done

install -m 0600 "${TMP_CRYPTTAB}" "${CRYPTTAB}"

# Rebuild the initramfs after crypttab and TPM2 enrollment have been finalized.
kver="$(
    find /lib/modules \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -printf '%f\n' |
    sort -V |
    tail -n 1
)"

test -n "${kver}"
dracut --force --kver "${kver}"
