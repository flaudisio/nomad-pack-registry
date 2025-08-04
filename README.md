# Nomad Pack Registry

Registry of customized packs for [Nomad Pack](https://github.com/hashicorp/nomad-pack).

## Using this registry

Add the registry:

```bash
nomad-pack registry add flaudisio github.com/flaudisio/nomad-pack-registry
```

Run a pack:

```bash
nomad-pack plan webapp --registry flaudisio
nomad-pack run webapp --registry flaudisio
```

## Deploying packs

1. (Recommended) Create a variables file for each deployment. Example:

    ```hcl
    # whoami/vars.hcl
    job_name = "whoami"
    image    = "traefik/whoami:latest"
    port     = 80
    ```

1. Plan the deployment to review the expected changes:

    ```bash
    nomad-pack plan webapp --registry flaudisio --name whoami -f whoami/vars.hcl --verbose
    ```

1. Run the deployment:

    ```bash
    nomad-pack run webapp --registry flaudisio --name whoami -f whoami/vars.hcl
    ```

## Un-deploying packs

1. Check the existing deployments for the target pack:

    ```bash
    nomad-pack status webapp
    nomad-pack status webapp --name whoami
    ```

1. Stop/destroy the deployment:

    ```bash
    # Stop the job
    nomad-pack stop webapp --registry flaudisio --name whoami -f whoami/vars.hcl

    # Remove the job
    nomad-pack stop webapp --registry flaudisio --name whoami -f whoami/vars.hcl --purge

    # Or use 'destroy' to stop and destroy in a single step
    nomad-pack destroy webapp --registry flaudisio --name whoami -f whoami/vars.hcl
    ```

## See also

- [Nomad Pack Community Registry](https://github.com/hashicorp/nomad-pack-community-registry)
- [Nomad Pack advanced usage](https://developer.hashicorp.com/nomad/tools/nomad-pack/advanced-usage)

## License

[MIT](LICENSE).
