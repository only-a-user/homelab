# Installation

## Cilium

The command I used loosely following [this documentation][cilium-helm-docs]. Both the values and the version might need to be updated.

```sh
helm install cilium oci://quay.io/cilium/charts/cilium \
  --version 1.19.1 \
  --namespace kube-system \
  --values values.yml
```

## OpenEBS

For the installation of OpenEBD I followed [this documentation][openebs-install].

The command to install OpenEBS is the following:

```sh
helm install openebs openebs/openebs \
  --namespace openebs \
  --create-namespace \
  --values values.yml
```

> **Important**
> If you have less than three worker nodes (or nodes which allow for scheduling) you will need to scale down the different replicas of your OpenEBS deployment, lest you want your deployment to fail.

After this apply the storage class specific to this setup:

```sh
kubectl apply -f storageclass.yml
```

## Metrics Server

Just run these two commands and the Metrics Server is up and running:

```sh
kubectl apply -f https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml
```

```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## Flux Operator

I installed FluxCD using the Flux Operator. You can follow [this installation guide][flux-operator]. I am using the Helm Chart to install the operator and then kustomize it using a `FluxInstance`:

```sh
helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
  --namespace flux-system \
  --create-namespace \
  --values values.yml
```

After this, just apply the instance:

```sh
kubectl apply -f instance.yml
```

[cilium-helm-docs]: https://docs.cilium.io/en/latest/installation/k8s-install-helm/
[openebs-install]: https://openebs.io/docs/quickstart-guide/installation#installation-via-helm
[flux-operator]: https://fluxoperator.dev/get-started/
