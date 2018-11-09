#!/bin/bash

set -x

export PATH=/home/imaxt/.local/bin:$PATH

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    /opt/conda/bin/pip install --user $EXTRA_PIP_PACKAGES
fi

# Run extra commands
"$@"
