# homeserver setup

this is the readme describing the whole setup of my homeserver

## server itself

the server itself is a minipc with 16G ram. it also has a 256G ssd as storage. it runs on ubuntu server 24 lts.

### kubernetes

installed on the server is a [k3s](https://k3s.io/) cluster. the cluster is bundled with traefik as its ingress. there are no specific configurations. obviously `kubectl`is also installed.

## deployment

for the deployment i use [fluxcd](https://fluxcd.io/).

the bootstrapping command is as follows:
```sh
flux bootstrap github \
  --token-auth \
  --owner=only-a-technical-user \
  --repository=homeserver-cluster \
  --branch=main \
  --path=deploy \
  --personal
```

## components

### jenkins

url: `lab.only-a-user.com/jenkins`

### authentik

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: authentik-bootstrap
  namespace: components
type: Opaque
data:
  bootstrap_password:
  bootstrap_token:
  bootstrap_email:
```

### cloudflared

to create the tunnel secret, create the tunnel in the dashboard. then retrieve the token and create a secret like this:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cloudflared-secret
  namespace: components
type: Opaque
stringData:
  values.yaml: |-
    cloudflare:
      tunnel_token: "<tunnel-token>"
```

### weave

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: oidc-auth
  namespace: dashboard
stringData:
  clientID: <client-id>
  clientSecret: <client-secret>
  issuerURL: <issuer-url>
  redirectURL: https://lab.only-a-user.com/oauth2/callback
  customScopes: openid,email,profile
```

### forgejo

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: forgejo-admin
  namespace: components
stringData:
  username: <admin_username>
  password: <password>
  email: "<mail>"
  passwordMode: keepUpdated
```

### harbor

The ht password needs to be generated using this command:

```sh
htpasswd -nbBC 10 harbor_registry_user {PASSWORD}
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: harbor-creds
  namespace: components
stringData:
  REGISTRY_PASSWD: <password>
  REGISTRY_HTPASSWD: <ht-passwd>
```
