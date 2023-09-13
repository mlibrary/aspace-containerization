## Deployment

This documents how to deploy ArchivesSpace using the 
[MITS Container Service](https://its.umich.edu/computing/virtualization-cloud/container-service/).
Perform the steps described in the sections below in order.
You can access the [Red Hat OpenShift Service on AWS here](https://containers.aws.web.umich.edu/).
### Create `.env.deployment` file
Create a `.env.deployment` file using `env.example` as a template and place it in `k8s`.
Modify values as needed for the OpenShift project you are setting up.
```shell
cp app/env.example k8s/base/.env.deployment
open k8s/.env.deployment
```
### Create OpenShift resources using the OpenShift CLI
After updating the database secret, you can use a single command to create resources in OpenShift
based on the Kubernetes objects in the `app` and `solr` directories under `base`.
The [`oc` command line interface](https://docs.openshift.com/container-platform/4.13/cli_reference/openshift_cli/getting-started-cli.html#installing-openshift-cli) is required.
For MacOS users, installation using [Homebrew](https://formulae.brew.sh/formula/openshift-cli) is recommended.

Once the CLI is installed, follow these steps.
1. Login in on the command line.
    1. From the OpenShift GUI, click on the dropdown with your username in the top-right hand corner of the window, and then select "Copy Login Command".
    1. Select the "umich-openid" button.
    1. Select the "Display Token" link.
    1. Copy the command beginning with `oc login --token=...`.
    1. Paste and run the command in your terminal.
1. Switch to the correct OpenShift project.
    ```shell
    oc project archivesspace
    ```
1. Create a secret based on the previously created `.env.deployment` file.
    ```shell
    oc create secret generic app-secret --from-env-file=k8s/base/.env.deployment
    ```
1. Issue the following command from the root of the repository.
    ```shell
    oc apply -f k8s/base -R --validate
    # Note you can add --dry-run=client to test how the command would affect the project.
    ```
### Verify Deployment
From the `Developer` view click `Topology`. Select the `app` which is listed under `Deployment` which should reveal a right side panel. In the right click the links under `Routes` to verify archivesspace is running.

## Kustomize

To make the creation of different variations of the resources in `base` transparent, simple, and repeatable,
we have provided `kustomize` artifacts that enable setup of a customized instance with a couple commands.
The resources defined under `base` form the foundation, and the configuration files in the separate directories
under `overlays` specify the changes, overrides, or additions necessary for that variant.

After logging in with the OpenShift CLI, follow these steps to create a variant in OpenShift.
(The commands below would be for the test instance, but you can change any mention of `test` for
one of the other variants or any new variant you want to create.)

1. Create an environment file based on `app/env.example`.
    ```shell
    cp app/env.example k8s/overlays/test/app/.env.deployment.test
    # Modify values as necessary for the variant
    ```

1. Run the `kubectl` control command targeting the overlay directory.
    ```shell
    kubectl kustomize k8s/overlays/test | oc apply -f - --validate-true
    ```
    Note: You can also review the resources generated first by omitting the latter half of the command.
    The `--dry-run=client` option is also available, as noted above.

Running the command on an empty OpenShift project will create all the necessary resources,
and start the Deployments. Because `solr` needs to be setup before `app` starts using it,
it may be necessary to scale down the `app` Deployment soon after it is created to ensure
there are no syncing issues between the services.

The command above can also be used to update projects, but there are some nuances.
Because some fields in resources cannot be modified currently in OpenShift,
you may need to delete some resources first and let the above command re-generate them
if those fields need to be modified (this is true of `host` in Routes).
Secrets are re-generated every time a change is made to the input environment file,
and a hash is appended to the name.
Deleting older secrets beforehand or cleaning up old secrets periodically is recommended.

Refer to the [`kubectl`/`kustomize` documentation](https://kubectl.docs.kubernetes.io/guides/) for help in modifying
`kustomization.yaml` files.
