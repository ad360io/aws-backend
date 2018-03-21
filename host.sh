#!/bin/bash
# 2018 QChain Inc. All Rights Reserved.
# License: Apache v2, see LICENSE.
#
#   host [runtime] [outdir] -- Build NumPy from within container.
#
#   Opts:
#       [runtime]    Python runtime (ex. "36").
#       [outdir]     Output directory (ex. "/var/task").
#

RUNTIME=$1
OUTDIR=$2
PYTHON=python$RUNTIME

# FUNCTIONS
# ---------

function build_qchain()
{
    # build qchain
    cd /qchain
    $PYTHON setup.py install --user
}

function copy_qchain
{
    # copy qchain to $LIBDIR
    cd /
    site=$($PYTHON -c "import os, qchain; print(os.path.dirname(qchain.__path__[0]))")
    cp "$site" "$OUTDIR"
}

# CALL
# ----

build_qchain
copy_qchain "$OUTDIR"
