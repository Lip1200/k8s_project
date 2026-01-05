# Online Boutique - Helm Chart

Helm chart pour déployer Online Boutique, une application e-commerce composée de 10 microservices.

## Prérequis

- Kubernetes cluster (Docker Desktop, Minikube, etc.)
- Helm v3+
- kubectl

## Architecture

| Service | Langage | Port | Description |
|---------|---------|------|-------------|
| frontend | Go | 8080 | Interface web |
| cartservice | C# | 7070 | Gestion du panier |
| productcatalogservice | Go | 3550 | Catalogue produits |
| currencyservice | Node.js | 7000 | Conversion devises |
| paymentservice | Node.js | 50051 | Paiements |
| shippingservice | Go | 50051 | Calcul livraison |
| emailservice | Python | 5000 | Envoi emails |
| checkoutservice | Go | 5050 | Validation commande |
| recommendationservice | Python | 8080 | Recommandations |
| adservice | Java | 9555 | Publicités |
| redis | Redis | 6379 | Cache panier |

## Déploiement

```bash
kubectl create namespace onlineboutique
helm install onlineboutique ./onlineboutique -n onlineboutique
kubectl port-forward svc/frontend 8080:8080 -n onlineboutique
```

Ouvrez http://localhost:8080

## Configuration

Modifier `values.yaml` pour personnaliser le déploiement.

### Images

Par défaut: `gcr.io/google-samples/microservices-demo/<service>:v0.8.0`

### Registry privé

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<user> \
  --docker-password=<token> \
  -n onlineboutique
```

Configurer `imagePullSecretsName: ghcr-secret` dans values.yaml.

## Désinstallation

```bash
helm uninstall onlineboutique -n onlineboutique
kubectl delete namespace onlineboutique
```

## Licence

Apache 2.0
