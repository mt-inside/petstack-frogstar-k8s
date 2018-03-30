# For now, there's nasty implicit, loose coupling between this and the
# cluster it's deploying to. I.e. admin cluster creds are expected to be in
# the current context in the kubeconfig. It's possible to fix this as both
# ways of accessing k8s (the k8s provider and the kubectl module) can make
# use of a bunch-o-certs, just need to plumb it in, i.e.
# - get it from cluster's remote tfstate in this deployment's data
# - use those data references in the k8s provisioner config here
# - use those data references as arguments to the "deploy" module, whence
# it can pass them to the k8s_manifest module instances which can use it.
# - eventually, write a k8s-manifest provider, that uses client-go so can
# support all these auth methods, and has a provider block where they can
# be configured.

