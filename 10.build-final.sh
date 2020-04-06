#!/bin/bash

SITES="clusters"
PREFIX="common"

if [[ ! ( ( "`hostname -f`" == "deb9.ncbr.muni.cz" ) || ( "`hostname -f`" == *"salomon"* ) )  ]]; then
    echo "unsupported build machine!"
    exit 1
fi

set -o pipefail

# ------------------------------------
if [ -z "$AMS_ROOT" ]; then
   echo "ERROR: This installation script works only in the Infinity environment!"
   exit 1
fi

# ------------------------------------------------------------------------------
module add cmake

# ------------------------------------------------------------------------------
# update revision number
VERS="2.`git rev-list --count HEAD`.`git rev-parse --short HEAD`"
if [ $? -ne 0 ]; then exit 1; fi

# names ------------------------------
NAME="qmutil"
ARCH="noarch"
MODE="single" 
echo "Build: $NAME:$VERS:$ARCH:$MODE"
echo ""

# build and install software ---------
cmake -DCMAKE_INSTALL_PREFIX="$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE" .
if [ $? -ne 0 ]; then exit 1; fi

make install
if [ $? -ne 0 ]; then exit 1; fi

# prepare build file -----------------
SOFTBLDS="$AMS_ROOT/etc/map/builds/$PREFIX"
VERIDX=`ams-map-manip newverindex $NAME:$VERS:$ARCH:$MODE`

cat > $SOFTBLDS/$NAME:$VERS:$ARCH:$MODE.bld << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Advanced Module System (AMS) build file -->
<build name="$NAME" ver="$VERS" arch="$ARCH" mode="$MODE" verindx="$VERIDX">
    <setup>
        <variable name="AMS_PACKAGE_DIR" value="$PREFIX/$NAME/$VERS/$ARCH/$MODE" operation="set" priority="modaction"/>
        <variable name="PATH" value="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/bin" operation="prepend"/>
    </setup>
</build>
EOF
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "Adding builds ..."
ams-map-manip addbuilds $SITES $NAME:$VERS:$ARCH:$MODE >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Distribute builds ..."
ams-map-manip distribute >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Rebuilding cache ..."
ams-cache rebuildall >> ams.log 2>&1
if [ $? -ne 0 ]; then echo ">>> ERROR: see ams.log"; exit 1; fi

echo "Log file: ams.log"
echo ""

