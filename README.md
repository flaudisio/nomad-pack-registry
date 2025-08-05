# Nomad Pack Registry

Registry of customized packs for [Nomad Pack](https://github.com/hashicorp/nomad-pack).

## Configuring the registry

To configure this registry for using its packs, run:

```bash
nomad-pack registry add <name> github.com/flaudisio/nomad-pack-registry [--ref <git ref>]
```

Example:

```bash
# Using the latest version
nomad-pack registry add flaudisio github.com/flaudisio/nomad-pack-registry

# Using specific version
nomad-pack registry add flaudisio github.com/flaudisio/nomad-pack-registry --ref v0.4.0
```

Multiple registry versions can be added. To deploy specific pack versions, use the `--ref` argument
(see below for examples).

## Deploying packs

1. (Recommended) Create a variables file for each deployment.  
   For example, to deploy the [whoami](https://github.com/traefik/whoami) application
   using the [webapp](packs/webapp) pack:

    ```hcl
    # whoami/variables.hcl
    job_name   = "whoami"
    image_name = "traefik/whoami"
    image_tag  = "latest"
    port       = 80
    ```

1. Plan the deployment to review the expected changes:

    ```bash
    nomad-pack plan webapp --name whoami -f whoami/variables.hcl --registry flaudisio --verbose

    # Using specific pack version
    nomad-pack plan webapp --name whoami -f whoami/variables.hcl --registry flaudisio --ref v0.4.0 --verbose
    ```

1. Run the deployment:

    ```bash
    nomad-pack run webapp --name whoami -f whoami/variables.hcl --registry flaudisio

    # Using specific pack version
    nomad-pack run webapp --name whoami -f whoami/variables.hcl --registry flaudisio --ref v0.4.0
    ```

See also the [examples](examples) folder for sample usage.

## Destroying deployments

1. Check the existing deployments for the target pack:

    ```bash
    nomad-pack status webapp
    nomad-pack status webapp --name whoami
    ```

1. Stop/destroy the deployment:

    ```bash
    # In two steps: stop then remove the job
    nomad-pack stop webapp --name whoami -f whoami/variables.hcl --registry flaudisio
    nomad-pack stop webapp --name whoami -f whoami/variables.hcl --purge --registry flaudisio

    # Or use 'destroy' to stop and destroy in a single step
    nomad-pack destroy webapp --name whoami -f whoami/variables.hcl --registry flaudisio
    ```

    If the pack was deployed using a specific version, make sure to also use the version in the
    stop/destroy commands:

    ```bash
    nomad-pack stop webapp --name whoami -f whoami/variables.hcl --registry flaudisio --ref v0.4.0
    nomad-pack stop webapp --name whoami -f whoami/variables.hcl --purge --registry flaudisio --ref v0.4.0

    nomad-pack destroy webapp --name whoami -f whoami/variables.hcl --registry flaudisio --ref v0.4.0
    ```

## Removing the registry

1. Check the configured registries:

    ```bash
    nomad-pack registry list
    ```

1. Remove the packs:

    ```bash
    # Remove all pack versions
    nomad-pack registry delete flaudisio

    # Remove only the latest pack versions
    nomad-pack registry delete flaudisio --ref latest

    # Remove specific pack versions
    nomad-pack registry delete flaudisio --ref v0.3.0
    nomad-pack registry delete flaudisio --ref v0.4.0
    ```

## Tests

See the [test](test) folder for details.

## See also

- [Nomad Pack Community Registry](https://github.com/hashicorp/nomad-pack-community-registry)
- [Nomad Pack advanced usage](https://developer.hashicorp.com/nomad/tools/nomad-pack/advanced-usage)

## License

[MIT](LICENSE).
