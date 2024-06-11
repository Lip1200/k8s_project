#!/bin/bash

declare -A images
images=(
    ["frontend"]="./src/frontend/Dockerfile"
    ["cartservice"]="./src/cartservice/src/Dockerfile"
    ["productcatalogservice"]="./src/productcatalogservice/Dockerfile"
    ["currencyservice"]="./src/currencyservice/Dockerfile"
    ["paymentservice"]="./src/paymentservice/Dockerfile"
    ["shippingservice"]="./src/shippingservice/Dockerfile"
    ["emailservice"]="./src/emailservice/Dockerfile"
    ["checkoutservice"]="./src/checkoutservice/Dockerfile"
    ["recommendationservice"]="./src/recommendationservice/Dockerfile"
    ["adservice"]="./src/adservice/Dockerfile"
)

for image in "${!images[@]}"; do
    dockerfile_path=${images[$image]}
    image_name="registry.gitlab.unige.ch/filipe.ramos/k8s-project/${image}:amd64"
    echo "Building ${image_name} from ${dockerfile_path}..."
    docker buildx build --platform=linux/amd64 -t ${image_name} -f ${dockerfile_path} .
    if [ $? -ne 0 ]; then
        echo "Failed to build ${image_name}"
        exit 1
    fi
    echo "Successfully built ${image_name}"
done


# Pousser chaque image vers le registre
for image in "${!images[@]}"; do
    image_name="registry.gitlab.unige.ch/filipe.ramos/k8s-project/${image}:amd64"
    echo "Pushing ${image_name}..."
    docker push ${image_name}
    if [ $? -ne 0 ]; then
        echo "Failed to push ${image_name}"
        exit 1
    fi
    echo "Successfully pushed ${image_name}"
done