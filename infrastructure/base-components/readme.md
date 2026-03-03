# Installation

## Cilium

The command I used loosely following [this documentation][cilium-helm-docs]. Both the values and the version might need to be updated.

```sh
helm install cilium oci://quay.io/cilium/charts/cilium \
  --version 1.19.1 \
  --namespace kube-system \
  --values values.yml
```

## Mayastor

For the installation of Mayastor I followed [this documentation][mayastor-talos-install-doc]. While this details how to configure Talos, it then references [this installation guide][openebs-install] on how to install Mayastor through OpenEBS.

The command to install OpenEBS is the following:

```sh
helm install openebs openebs/openebs \
  --namespace openebs \
  --create-namespace \
  --values values.yml
```

> **Important**
> If you have less than three worker nodes (or nodes which allow for scheduling) you will need to scale down the different replicas of your OpenEBS deployment, lest you want your deployment to fail.

[cilium-helm-docs]: https://docs.cilium.io/en/latest/installation/k8s-install-helm/
[mayastor-talos-install-doc]: https://openebs.io/docs/Solutioning/openebs-on-kubernetes-platforms/talos
[openebs-install]: https://openebs.io/docs/quickstart-guide/installation#installation-via-helm
