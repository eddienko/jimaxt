#!/bin/bash

set -x

export PATH=/home/imaxt/.local/bin:$PATH

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    if [ "$EXTRA_INDEX_URL" ]; then
        /opt/conda/bin/pip install --user $EXTRA_PIP_PACKAGES --extra-index-url=$EXTRA_INDEX_URL
    else
        /opt/conda/bin/pip install --user $EXTRA_PIP_PACKAGES
    fi
fi

# Run extra commands
"$@"
