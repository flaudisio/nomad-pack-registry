#!/usr/bin/env bash
#
# nomad-pack-docs.sh
#
# pre-commit hook for creating Markdown documentation for 'variables.hcl' files
# by using terraform-docs under the hood.
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

function main()
{
    trap remove_temp_files EXIT

    local tf_docs_args=()

    while true ; do
        # Extract terraform-docs arguments
        # Note: only the '--arg=value' format is supported
        if [[ "$1" == --*=* ]] ; then
            tf_docs_args+=( "$1" )
            shift
        else
            break
        fi
    done

    local filepath
    local dir
    local temp_file

    for filepath in "$@" ; do
        dir="$( dirname "$filepath" )"

        # Hack: 'variables.hcl' files are not loaded by terraform-docs, so we create a temporary
        # '.tf' file to make it work
        # See https://github.com/terraform-docs/terraform-config-inspect/blob/5b88c7ed/tfconfig/load.go#L128
        if [[ "$filepath" == *variables.hcl ]] ; then
            temp_file="${filepath}.temp.tf"
            FILES_TO_REMOVE+=( "$temp_file" )

            cp "$filepath" "$temp_file"
        fi

        terraform-docs markdown "${tf_docs_args[@]}" --output-mode=inject --output-file=README.md "$dir"
    done
}

main "$@"
