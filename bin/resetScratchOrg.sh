#!/bin/bash

###############################################################
# 
# bin/resetScratchOrg {org_alias}
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

# Delete any previous scratch org with same alias
if [ 10 -gt "$progress_marker_value" ]
  then
    sf org delete scratch --no-prompt --target-org $org_alias
    echo 10 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=10
fi
# echo "progress_marker_value C == $progress_marker_value"

# exit script when any command fails.  From here forward, if there is a failure, we want the script to fail
set -e 

# Create new scratch org
if [ 20 -gt "$progress_marker_value" ]
  then
    sf org create scratch --wait 30 --duration-days 2 --definition-file config/project-scratch-def.json --alias $org_alias
    echo 20 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=20
fi

# Set scratch org and scratch default user to EST timezone. Also purge sample data.
if [ 30 -gt "$progress_marker_value" ]
  then
    sf data update record --sobject User --where "Name='User User'" --values "TimeZoneSidKey='America/New_York'" --target-org $org_alias
    echo 30 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=30
fi

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
    sfdx org open --path lightning/setup/SetupOneHome/home --target-org $org_alias
    echo ""
    echo "Scratch org $org_alias is ready"
    echo ""
    echo 99 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=99
fi

echo "Setting $org_alias as the default username"
sfdx config set target-org=$org_alias

# remove marker file
rm "$temp_dir/$progress_marker_filename"
