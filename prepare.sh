#!/bin/bash

# set -x

export PATH=/home/jimaxt/.local/bin:$PATH

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    /opt/conda/bin/pip install --user $EXTRA_PIP_PACKAGES
fi

if [ "$#" -gt 0 ]
then
  exec "$@"
fi

