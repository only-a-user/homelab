# Installation

## Image

I used the [Talos Image Factory](https://factory.talos.dev) to generate a nocloud image. It uses the following extensions:

```yaml
customization:
    systemExtensions:
        officialExtensions:
            - siderolabs/iscsi-tools
            - siderolabs/qemu-guest-agent
            - siderolabs/util-linux-tools
```

The Terraform provider I used does not allow for ISO images to be used for `cloud-init` which I found strage, but I could circumvent this, by using the raw disk images.
For that I had to take the following steps:
- Download the `nocloud-amd64.raw.xz` image
- Decompress it with `unxz`
- Upload it to Proxmox under `local/import`
- Reference it directly in my Terraform configuration
