# Changelog

## v0.9.0 - 2026-02-21

### Features

- Expand group volume config

### Refactor

- [**breaking**] Rename `consul_service_` inputs

## v0.8.0 - 2026-02-11

### Features

- Add support to custom Traefik router rules

### Refactor

- [**breaking**] Add support to multiple Traefik hosts

## v0.7.0 - 2026-02-11

### Features

- Add support to use an NFS volume at task level

## v0.6.0 - 2026-02-05

### Features

- Add support to group volume
- Add support to task volumes
- Add support to task templates
- Add support to task command and args
- Add support to task user
- Add support to static port

### Refactor

- Remove unncessary resource input defaults
- Move update strategy defaults to template

## v0.5.0 - 2025-09-12

### Refactor

- Improve output message

### Documentation

- Standardize `env` input description

## v0.4.0 - 2025-08-05

### Features

- Add `update_strategy` variable

### Bug fixes

- Fix HTTP headers injection

### Refactor

- [**breaking**] Rename variable for custom HTTP headers
- [**breaking**] Rename service-related variables
- [**breaking**] Disable Traefik tags by default
- [**breaking**] Add support to multiple Traefik endpoints
- [**breaking**] Disable Nomad secrets by default
- [**breaking**] Change default port number and label
- [**breaking**] Use separate inputs for image name and tag
- Use template for the job name
- Fix comment delimiters

### Documentation

- Add usage and test instructions
- Update variables file header

### Styling

- Move variable declaration

## v0.3.0 - 2025-08-03

### Documentation

- Update pack URL

### Styling

- Improve template indentation

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
