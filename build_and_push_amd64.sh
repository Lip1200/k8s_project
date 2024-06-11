#!/bin/bash

declare -A images
images=(
    ["frontend"]="./src/frontend"
    ["cartservice"]="./src/cartservice/src"
    ["productcatalogservice"]="./src/productcatalogservice"
    ["currencyservice"]="./src/currencyservice"
    ["paymentservice"]="./src/paymentservice"
    ["shippingservice"]="./src/shippingservice"
    ["emailservice"]="./src/emailservice"
    ["checkoutservice"]="./src/checkoutservice"
    ["recommendationservice"]="./src/recommendationservice"
    ["adservice"]="./src/adservice"
)

# Construire et pousser toutes les images
for image in "${!images[@]}"; do
    context_path=${images[$image]}
    image_name="registry.gitlab.unige.ch/filipe.ramos/k8s-project/${image}:amd64"
    
    echo "Building ${image_name} from ${context_path}..."
    docker buildx build -t ${image_name} ${context_path} --platform=linux/amd64 --load
    if [ $? -ne 0 ]; then
        echo "Failed to build ${image_name}"
        exit 1
    fi
    echo "Successfully built ${image_name}"
    
    echo "Pushing ${image_name}..."
    docker push ${image_name}
    if [ $? -ne 0 ]; then
        echo "Failed to push ${image_name}"
        exit 1
    fi
    echo "Successfully pushed ${image_name}"
done
