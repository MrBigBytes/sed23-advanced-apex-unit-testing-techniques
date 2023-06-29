#!/bin/bash

###############################################################
# 
# bin/setupSandboxOrg.sh {org_alias}
# 
###############################################################

org_alias=$1

if [ -z "$1" ]
  then
    echo "No org_alias argument supplied"
    exit 1
fi
echo org_alias is $org_alias

temp_dir=temp
progress_marker_filename=_buildprogressmarker_$org_alias

# Does the temp directory exist?
if [ ! -d "$temp_dir" ]
  then
    mkdir "$temp_dir"
fi 

# Does the progressmarker file exist?
if [ ! -f "$temp_dir/$progress_marker_filename" ]
  then
    echo 0 > "$temp_dir/$progress_marker_filename"
fi 

progress_marker_value=$(<"$temp_dir/$progress_marker_filename")

if [ -z "$progress_marker_value" ]
  then
    progress_marker_value=0
fi

# exit script when any command fails.  From here forward, if there is a failure, we want the script to fail
set -e 

# Install all dependencies
if [ 40 -gt "$progress_marker_value" ]
  then
    rm -fR "$temp_dir/fflib-apex-mocks"
    git clone -q --no-tags https://github.com/apex-enterprise-patterns/fflib-apex-mocks.git $temp_dir/fflib-apex-mocks
    cd $temp_dir/fflib-apex-mocks
    sf project deploy start --ignore-conflicts --target-org $org_alias
    cd ../..
    # rm -fR "$temp_dir/fflib-apex-mocks"
    echo 40 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=40
fi

if [ 43 -gt "$progress_marker_value" ]
  then
    rm -fR "$temp_dir/fflib-apex-common"
    git clone -q --no-tags https://github.com/apex-enterprise-patterns/fflib-apex-common.git $temp_dir/fflib-apex-common
    cd "$temp_dir/fflib-apex-common"
    sf project deploy start --ignore-conflicts --target-org $org_alias
    cd ../..
    # rm -fR "$temp_dir/fflib-apex-common"
    echo 43 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=43
fi

# Push source code to org.
if [ 50 -gt "$progress_marker_value" ]
  then
    sf project deploy start --ignore-conflicts --target-org $org_alias
    echo 50 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=50
fi

# Open the org
if [ 99 -gt "$progress_marker_value" ]
  then
    sf org open --path lightning/setup/SetupOneHome/home --target-org $org_alias
    echo ""
    echo "Sandbox org $org_alias is ready"
    echo ""
    echo 99 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=99
fi

# remove marker file
rm "$temp_dir/$progress_marker_filename"
