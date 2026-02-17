#!/bin/bash

function help() {
    cat <<EOF | echo -e "$(cat -)"
This script sets up a folder structure for a Terraform module.
It copies standard data-objects.tf and variables.tf files into the current directory.

This should be run from within your terraform folder, or at the root of a TF modulerepository.

EOF
}

function usage() {
    cat <<EOF | echo -e "$(cat -)"
Usage: $0 MODULE_NAME
EOF
}

MODULE_NAME=$1
SOURCE_DIR=$(dirname "$0")

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

if [[ $1 = '-h' ]]; then
  help
  exit 1
fi

cp $SOURCE_DIR/data-objects.tf ./
cp $SOURCE_DIR/variables.tf ./
cp $SOURCE_DIR/README.md ./
cp $SOURCE_DIR/providers.tf ./

sed -i "s/MODULENAME/$MODULE_NAME/g" README.md
