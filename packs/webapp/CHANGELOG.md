# Changelog

## Unreleased

## v0.2.0 - 2025-08-01

### Features

- Add `node_pool` variable
- Add variable for Traefik endpoint

### Refactor

- Use helper to define the job location
- [**breaking**] Rename port label to `app`
- [**breaking**] Change default datacenter to `dc1`
- [**breaking**] Rename service variables
- Use helper to define service Traefik tags
- Make `namespace` variable optional
- [**breaking**] Rename `service_name` input to `job_name`
- [**breaking**] Remove `service_basedomain` variable

### Documentation

- Improve variable descriptions

### Styling

- Improve job indentation
- Fix environment indentation

### Testing

- Initial support for pack tests

## v0.1.0 - 2025-07-30

### Features

- Initialize pack

### Refactor

- Use default namespace

### Documentation

- Remove current version from README
- Apply nomad-pack-docs updates

### Miscellaneous tasks

- Add workflow to validate packs
- Update template filename
- Update metadata.hcl files
