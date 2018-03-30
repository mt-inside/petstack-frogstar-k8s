```bash
$ ?? terraform init modules/cluster/gcloud
$ cd deployment/frogstar-b/infra
$ terraform init
$ terraform plan -out plan.tfplan
$ terraform apply plan.tfplan
```

```bash
$ terraform plan -destory -out plan.tfplan
$ terraform apply plan.tfplan
```

```bash
$ terraform graph > deps.dot
$ dot -Tpdf deps.dot > deps.pdf
```

# TODO
* Stop kubectl just using the ambient context! Get the necc endpoint info
  from the previous step (this could be the dep?) and use that!
* Make frogstar-b deployment one thing, just two files. I think the problem
  is that one module can't depend on another, and there's no other way to
ensure the ordering. Just hack it by writing an infra output onto a tag of
a deploy thing?
* Use helm provider to install everything possible
* Factor out k8s version, flux version, git repo to sync
* State in a remote, persistent place.
  * Can do this with a module making state project & disk, then everything
    else setting their data location to that, BUT that's apparently not best
    practice. Should have a makefile (probably run under docker) that uses the
    provider's tool to do this bootstrapping e.g. CF or the gcloud API
* automate PIs as much as possible - script to run hypriot/flash, mount,
  add cloud-config file which points to mt's install_k8s (downloads it from
  a precursor to a PXE boot env?). Get join token from same place? race to
  master using consul?
* PXE boot PIs. PXE environment is basically an initramdisk, so can run
  ignition on PIs that way?
* Write kubes from scratch on AWS for frogstar-c. Container linux +
  ignition. Packer too.
* Flux to read env
* Write a TF k8s provider that uses client-go not kubectl, so has all the
  auth options etc, but takes manifest files
* Run vault, one login to that, have it keep github, cloudflare etc tokens
  and pull them down with TF vault data for provider configs and bootstrap
  compontent secrets.
* Look at bitnami sealed secrets for user secrets (grafana admin password
  etc)
* Move empty.org.uk over to cloudflare, get API access going, add
  $deployment_name as an A to the endpoint
* Work out a global cluster parameters thing with joel (render a global
  helm values file? problem cause it's got to apply to ingress too) for
  cluster name (e.g. into the grafana deployment), public DNS (in all the
  ingress objects), git repo and branch to follow, etc. Seems like a
  two-stage thing like secrets:
  * System config, e.g. git branch to follow, can just be TF-rendered into
    a config map
  * User config, e.g. public DNS, cluster name for logging is harder. Put
    it in a configmap for a mutatingwebhook like qwack?
* Try to work out how to do local dev. Sync with throw-away repo? Sync with
  a local dir somehow? Just manually apply stuff (flux won't delete it, no
  kube-diff on dev clusters)
* "dev" switch that: skips kube-diff, binds user to cluster-admin, follows
  dev branch, etc
