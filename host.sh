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
    ls -la qchain/nem
    $PYTHON -m pip install . --user
}

function copy_qchain
{
    # copy qchain to $LIBDIR
    cd /
    site=$($PYTHON -c "import qchain; print(qchain.__path__[0])")
    ls -la $site/nem
    cp -a "$site" "$OUTDIR"
}

# CALL
# ----

build_qchain
copy_qchain "$OUTDIR"
