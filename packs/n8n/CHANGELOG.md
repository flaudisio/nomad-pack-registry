# Changelog

## v0.12.0 - 2026-06-07

### Features

- Configure `shutdown_delay`

### Documentation

- Apply pre-commit fixes

## v0.10.0 - 2026-05-12

### Features

- Add prestart container to wait for DB

### Refactor

- Make DB check more robust
- Ensure service and task names consistency

### Miscellaneous tasks

- Send wait message to stderr
- Improve output message

## v0.9.0 - 2026-02-21

### Refactor

- [**breaking**] Rename `consul_service_tags` input

## v0.8.0 - 2026-02-11

### Features

- Add support to custom Traefik router rules

### Refactor

- [**breaking**] Add support to multiple Traefik hosts

## v0.7.0 - 2026-02-11

### Features

- Allow Postgres resource customization
- Add support to NFS volumes
- Add support to app group volume
- Create pack

### Refactor

- Use separate groups for app and DB

### Documentation

- Improve input descriptions
- Document prerequisites and add examples
