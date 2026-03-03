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

**TODO** add instructions on how to create disk pools.
### Creating Disk Pools

In order to actually create `PVCs` we need to create disk pools utilizing the additional disks that we deployed on our worker nodes. For that we need the following information:

- The node names
- The unqiue identifiers of the disks

The latter we can get using this talosctl command:

```sh
talosctl -n "<node-ip>" ls -l /dev/disk/by-id
```

If we have this, we can create disk pools like this:

```yml
apiVersion: "openebs.io/v1beta3"
kind: DiskPool
metadata:
  name: <pool-name>
  namespace: openebs
spec:
  node: <node-name>
  disks: ["aio:///dev/disk/by-id/<id>"]
  topology:
    labelled:
      topology-key: topology-value # you might want to adjust this as well
```

You can then add more customized storage classes or use the default one. You also can set one of these storage classes to be your default:

```sh
kubectl patch storageclass <storage-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

After this, you are good to go.

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

[cilium-helm-docs]: https://docs.cilium.io/en/latest/installation/k8s-install-helm/
[mayastor-talos-install-doc]: https://openebs.io/docs/Solutioning/openebs-on-kubernetes-platforms/talos
[openebs-install]: https://openebs.io/docs/quickstart-guide/installation#installation-via-helm
[flux-operator]: https://fluxoperator.dev/get-started/
