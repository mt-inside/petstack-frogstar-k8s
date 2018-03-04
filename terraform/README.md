```bash
$ terraform init modules/cluster/gcloud
$ terraform init deployment/frogstar-b
$ terraform plan -out plan.tfplan deployment/frogstar-b
$ terraform apply plan.tfplan
```

```bash
$ terraform plan -destory -out plan.tfplan deployment/frogstar-b
$ terraform apply plan.tfplan
```

```bash
$ terraform graph > deps.dot
$ dot -Tpdf deps.dot > deps.pdf
```

# TODO
State in a remote, persistent place.
* Can do this with a module making state project & disk, then everything
  else setting their data location to that?
* Add modules to bootstrap in tiller, flux, etc.
* Use those modules in frogstar-b deployment
* Write kubes from scratch on AWS for frogstar-c
