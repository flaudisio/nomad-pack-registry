#!/usr/bin/env bash

set -e
set -o pipefail

readonly OUTPUT_DIR="rendered"

ERROR=0

function _msg()
{
    echo "$*" >&2
}

function _run()
{
    _msg "+ $*"
    "$@"
}

function validate_pack()
{
    local -r pack_dir="$1"
    local -r pack_name="$( basename "$pack_dir" )"
    local -r rendered_dir="${OUTPUT_DIR}/${pack_name}"
    local var_file
    local render_args=()

    for var_file in "${pack_dir}"/{.ci,test}/vars-*.hcl ; do
        [[ -f "$var_file" ]] || continue

        render_args+=(--var-file "$var_file")
    done

    _msg "--> Rendering pack '$pack_dir'"

    _run rm -rf -- "$rendered_dir"

    if ! _run nomad-pack render "${render_args[@]}" --to-dir "$OUTPUT_DIR" "$pack_dir" ; then
        ERROR=1
        return
    fi

    _msg "--> Validating rendered pack '$rendered_dir'"

    for job_file in "${rendered_dir}"/*.{nomad,hcl} ; do
        [[ -f "$job_file" ]] || continue

        _msg "--> Validating file '$job_file'"

        # `fmt` catches syntax errors in the rendered job file
        _run nomad fmt "$job_file" || ERROR=1

        # `validate` catches semantic issues, especially if run against a live Nomad agent
        _run nomad validate "$job_file" || ERROR=1
    done
}

function main()
{
    if [[ -z "$1" ]] ; then
        _msg "Usage: $0 path/to/pack [path/to/pack]"
        exit 2
    fi

    local pack_dir

    for pack_dir in "$@" ; do
        validate_pack "$pack_dir"
    done

    if [[ $ERROR -ne 0 ]] ; then
        _msg "-----------------------------------------------"
        _msg "ERROR: validation failed for one or more packs."
        _msg "-----------------------------------------------"
        exit 1
    fi

    _msg "-------------------------------------------"
    _msg "All packs have been validated successfully!"
    _msg "-------------------------------------------"
}

main "$@"
