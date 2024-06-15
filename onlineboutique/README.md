### README.md

```markdown
# K8s Project

Ce projet Kubernetes déploie plusieurs services d'une boutique en ligne sur un cluster Kubernetes. Les services incluent `frontend`, `cartservice`, `productcatalogservice`, `currencyservice`, `paymentservice`, `shippingservice`, `emailservice`, `checkoutservice`, `recommendationservice`, et `adservice`.

## Prérequis

- Kubernetes cluster configuré (Microk8s,..)
- Helm installé
- Kubectl installé
- Accès à un registre d'images Docker (GitLab, Docker Hub, etc.)
- Fichier de configuration des credentials GCP nécessaire!

## Configuration

### Configuration des Secrets

Créez un secret pour vos credentials GCP :

```sh
kubectl create secret generic gcp-credentials --from-file=path/to/your/gcp-credentials.json
```

Créez un secret pour l'accès au registre d'images :

```sh
kubectl create secret docker-registry gitlab-registry-secret \
  --docker-server=<your-registry-server> \
  --docker-username=<your-username> \
  --docker-password=<your-password> \
  --docker-email=<your-email>
```

### Fichier `values.yaml`

Le fichier `values.yaml` contient toutes les configurations nécessaires pour le déploiement des services. Assurez-vous que ce fichier est configuré correctement :

```yaml
replicaCount: 1

imagePullSecretsName: gitlab-registry-secret

podAnnotations: {}

podSecurityContext: {}
securityContext: {}

serviceType: LoadBalancer
servicePort: 80

ingress:
  enabled: true
  ingressClassName: "nginx"
  ingressAnnotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60s"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "60s"
  ingressHosts:
    - host: <your-ingress-host>
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: frontend
              port:
                number: 80

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 3
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80

resources:
  requests:
    cpu: "200m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"

services:
  - name: frontend
    image: <your-registry>/filipe.ramos/k8s-project/frontend:latest
    port: 8080
    env:
      - name: PRODUCT_CATALOG_SERVICE_ADDR
        value: productcatalogservice:80
      - name: CURRENCY_SERVICE_ADDR
        value: currencyservice:7000
      - name: CART_SERVICE_ADDR
        value: cartservice:80
      - name: RECOMMENDATION_SERVICE_ADDR
        value: recommendationservice:80
      - name: CHECKOUT_SERVICE_ADDR
        value: checkoutservice:80
      - name: SHOPPING_ASSISTANT_SERVICE_ADDR
        value: "shoppingassistantservice:8080"
      - name: AD_SERVICE_ADDR
        value: "adservice:8080"
      - name: SHIPPING_SERVICE_ADDR
        value: "shippingservice:8080"
  - name: cartservice
    image: <your-registry>/filipe.ramos/k8s-project/cartservice:latest
    port: 80
  - name: productcatalogservice
    image: <your-registry>/filipe.ramos/k8s-project/productcatalogservice:latest
    port: 80
    env:
      - name: EXTRA_LATENCY
        value: "5s"
  - name: currencyservice
    image: <your-registry>/filipe.ramos/k8s-project/currencyservice:latest
    port: 7000
    env:
      - name: PORT
        value: "7000"
      - name: GOOGLE_CLOUD_PROJECT
        value: "project-id"
      - name: GOOGLE_APPLICATION_CREDENTIALS
        value: "/etc/credentials/gcp-credentials.json"
      - name: MAIN_PROTO_PATH
        value: './proto/demo.proto'
      - name: HEALTH_PROTO_PATH
        value: './proto/grpc/health/v1/health.proto'
  - name: paymentservice
    image: <your-registry>/filipe.ramos/k8s-project/paymentservice:latest
    port: 80
    env:
      - name: PORT
        value: "8080"
      - name: GOOGLE_CLOUD_PROJECT
        value: "your-project-id"
  - name: shippingservice
    image: <your-registry>/filipe.ramos/k8s-project/shippingservice:latest
    port: 80
  - name: emailservice
    image: <your-registry>/filipe.ramos/k8s-project/emailservice:latest
    port: 80
  - name: checkoutservice
    image: <your-registry>/filipe.ramos/k8s-project/checkoutservice:latest
    port: 80
    env:
      - name: SHIPPING_SERVICE_ADDR
        value: shippingservice:80
      - name: PRODUCT_CATALOG_SERVICE_ADDR
        value: productcatalogservice:80
      - name: CURRENCY_SERVICE_ADDR
        value: currencyservice:7000
      - name: CART_SERVICE_ADDR
        value: cartservice:80
      - name: EMAIL_SERVICE_ADDR
        value: emailservice:80
      - name: PAYMENT_SERVICE_ADDR
        value: paymentservice:80
      - name: RECOMMENDATION_SERVICE_ADDR
        value: recommendationservice:80
  - name: recommendationservice
    image: <your-registry>/filipe.ramos/k8s-project/recommendationservice:latest
    port: 80
    env:
      - name: PRODUCT_CATALOG_SERVICE_ADDR
        value: productcatalogservice:80
  - name: adservice
    image: <your-registry>/filipe.ramos/k8s-project/adservice:latest
    port: 80

volumes:
  - name: gcp-credentials
    secret:
      secretName: gcp-credentials

imagePullSecrets:
  - name: gitlab-registry-secret
```

## Déploiement

Pour déployer le projet sur votre cluster Kubernetes, suivez les étapes ci-dessous :

1. Assurez-vous que les secrets nécessaires sont créés comme indiqué dans la section de configuration.
2. Appliquez les configurations et déployez les services à l'aide de Helm :

```sh
helm upgrade --install onlineboutique ./onlineboutique
```

## Accès au Service

Une fois les services déployés, vous pouvez accéder à l'application via l'URL spécifiée dans votre configuration Ingress. Par exemple :

```
http://10.195.70.44.nip.io
```

## Dépannage

### Erreurs de Port

Si vous voyez des erreurs liées aux `containerPort` manquants, assurez-vous que chaque service a son `containerPort` correctement défini dans le fichier `values.yaml`.

### Logs des Pods

Pour vérifier les logs des pods en cas de problème, utilisez la commande suivante :

```sh
kubectl logs <pod-name>
```

### Réinstaller les Déploiements

Si vous rencontrez des problèmes persistants, vous pouvez essayer de supprimer les déploiements problématiques et de réinstaller :

```sh
kubectl delete deployment frontend currencyservice
helm upgrade --install onlineboutique ./onlineboutique
```

## Contribuer

Les contributions sont les bienvenues ! Veuillez créer une issue ou soumettre une pull request pour toute amélioration ou correction.

## Licence

Ce projet est sous licence Apache 2.0. Voir le fichier [LICENSE](LICENSE) pour plus de détails.
```