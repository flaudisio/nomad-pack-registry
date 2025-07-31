#!/usr/bin/env bash
#
# nomad-pack-docs.sh
#
# Script for generating Markdown documentation for Nomad packs.
#
# Dependencies:
# - hcl2json (https://github.com/tmccombs/hcl2json)
# - jq (https://github.com/jqlang/jq)
# - terraform-docs (https://github.com/terraform-docs/terraform-docs)
#
##

set -e
set -u
set -o pipefail

FILES_TO_REMOVE=()

function remove_temp_files()
{
    if [[ -n "${FILES_TO_REMOVE[*]}" ]] ; then
        rm -f -- "${FILES_TO_REMOVE[@]}"
    fi
}

function inject_inputs()
{
    local filepath="$1"
    local pack_dir="$2"
    local temp_file

    # Hack: 'variables.hcl' files are not loaded by terraform-docs, so we create a temporary
    # '.tf' file to make it work
    # See https://github.com/terraform-docs/terraform-config-inspect/blob/5b88c7ed/tfconfig/load.go#L128
    temp_file="${filepath}.temp.tf"
    FILES_TO_REMOVE+=( "$temp_file" )

    cp "$filepath" "$temp_file"

    terraform-docs markdown \
        --sort-by=required \
        --show=inputs \
        --output-mode="inject" \
        --output-file="README.md" "$pack_dir"
}

function inject_metadata()
{
    local pack_metadata
    local pack_name
    local pack_description
    local readme_header

    pack_metadata="$( hcl2json "${pack_dir}/metadata.hcl" )"
    pack_name="$( jq -r '.pack[0].name' <<< "$pack_metadata" )"
    pack_description="$( jq -r '.pack[0].description' <<< "$pack_metadata" )"

    readme_header="# $pack_name\n\n${pack_description:-"None"}."

    # Ref: https://stackoverflow.com/a/72858701/5463829
    echo -e "$readme_header" \
        | sed \
            -e '/<!-- BEGIN_PACK_METADATA -->/,/<!-- END_PACK_METADATA -->/ { r /dev/stdin' \
            -e '; //!d }' \
            -i "${pack_dir}/README.md"
}

function main()
{
    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [terraform-docs args] paths..." >&2
        exit 2
    fi

    trap remove_temp_files EXIT

    local filepath
    local pack_dir

    for filepath in "$@" ; do
        pack_dir="$( dirname "$filepath" )"

        if [[ "$filepath" =~ /(vars|variables)\.hcl$ ]] ; then
            inject_inputs "$filepath" "$pack_dir"
        fi

        if [[ "$filepath" =~ /metadata.hcl$ ]] ; then
            inject_metadata "$pack_dir"
        fi
    done
}

main "$@"
