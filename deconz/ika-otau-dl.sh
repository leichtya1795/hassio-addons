#!/bin/bash

URL_IKEA="http://fw.ota.homesmart.ikea.net/feed/version_info.json"

while True; do

    # fetch data
    if ! IKEA_DATA="$(curl -sL ${URL_IKEA})"; then
        echo "[Info] Can't fetch data from ikea!"
        sleep 1800
        continue
    fi

    IKEA_DATA_SIZE="$(echo "${IKEA_DATA}" | jq --raw-output '. | length')"
    for (( i=0; i < "${IKEA_DATA_SIZE}"; i++ )); do
        OTAU_URL=$(echo "${IKEA_DATA}" | jq --raw-output "[$i].fw_binary_url // empty")

        if [ -n "${OTAU_URL}" ]; then
            continue
        fi

        OTAU_FILE="/data/otau/${OTAU_URL##*/}"
        if [ -f "${OTAU_FILE}" ]; then
            continue
        fi

        curl -s -L -o "${OTAU_FILE}" "${OTAU_URL}"
    done

    sleep 18000
done
