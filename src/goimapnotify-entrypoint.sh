#!/usr/bin/env bash

main() {

    local flags=('--conf' '/etc/imapnotify/config.yaml')

    if [[ "${IMAPNOTIFY_LIST_ONLY:-}" == "true" ]]; then
        exec /usr/local/bin/goimapnotify "${flags[@]}" -list
        return
    fi

    if [[ -n "${IMAPNOTIFY_LOG_LEVEL:-}" ]]; then
        flags+=('--log-level' "${IMAPNOTIFY_LOG_LEVEL}")
    fi

    if [[ -n "${IMAPNOTIFY_WAIT:-}" ]]; then
        flags+=('--wait' "${IMAPNOTIFY_WAIT}")
    fi

    set -x
    exec /usr/local/bin/goimapnotify "${flags[@]}"
}

main "$@"
