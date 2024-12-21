#!/usr/bin/env bash

export PORT=${PORT:-8000}
export WORKERS=${WORKERS:-1}

# Enhanced optimization of local API services
export UNSTRUCTURED_PARALLEL_MODE_THREADS=6
export UNSTRUCTURED_PARALLEL_RETRY_ATTEMPTS=3
export UNSTRUCTURED_PARALLEL_MODE_SPLIT_SIZE=3
export UNSTRUCTURED_MEMORY_FREE_MINIMUM_MB=4096
# Disable telemetry/tracking
export DO_NOT_TRACK=true
export SCARF_NO_ANALYTICS=true
MAX_LIFETIME_SECONDS=7200


NUMREGEX="^[0-9]+$"
GRACEFUL_SHUTDOWN_PERIOD_SECONDS=3600
TIMEOUT_COMMAND='timeout'
OPTIONAL_TIMEOUT=''

if [[ -n $MAX_LIFETIME_SECONDS ]]; then
    if ! command -v $TIMEOUT_COMMAND &> /dev/null; then
        TIMEOUT_COMMAND='gtimeout'
        echo "Warning! 'timeout' command is required but not available. Checking for gtimeout."
    elif ! command -v $TIMEOUT_COMMAND &> /dev/null; then
        echo "Warning! 'gtimeout' command is required but not available. Running without max lifetime."
    elif [[ $MAX_LIFETIME_SECONDS =~ $NUMREGEX ]]; then
        OPTIONAL_TIMEOUT="timeout --preserve-status --foreground --kill-after ${GRACEFUL_SHUTDOWN_PERIOD_SECONDS} ${MAX_LIFETIME_SECONDS}"
        echo "Server's lifetime set to ${MAX_LIFETIME_SECONDS} seconds."
    else
        echo "Warning! MAX_LIFETIME_SECONDS was not properly set, an integer was expected, got ${MAX_LIFETIME_SECONDS}. Running without max lifetime."
    fi
fi

${OPTIONAL_TIMEOUT} \
    uvicorn prepline_general.api.app:app \
    --log-config logger_config.yaml \
    --host 0.0.0.0 \
    --port "$PORT" \
    --workers "$WORKERS" \

echo "Server was shutdown"
[ -n "$MAX_LIFETIME_SECONDS" ] && echo "Reached timeout of $MAX_LIFETIME_SECONDS seconds"
