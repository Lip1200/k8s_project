#!/bin/sh

# Définir les images et leurs chemins de contexte
images="frontend:./src/frontend
cartservice:./src/cartservice/src
productcatalogservice:./src/productcatalogservice
currencyservice:./src/currencyservice
paymentservice:./src/paymentservice
shippingservice:./src/shippingservice
emailservice:./src/emailservice
checkoutservice:./src/checkoutservice
recommendationservice:./src/recommendationservice
adservice:./src/adservice"

# Construire et pousser toutes les images
for image_context in $images; do
    image_name=$(echo $image_context | cut -d':' -f1)
    context_path=$(echo $image_context | cut -d':' -f2)
    full_image_name="registry.gitlab.unige.ch/filipe.ramos/k8s-project/${image_name}:amd64"
    
    echo "Building ${full_image_name} from ${context_path}..."
    docker build -t ${full_image_name} ${context_path} --platform=linux/amd64
    if [ $? -ne 0 ]; then
        echo "Failed to build ${full_image_name}"
        exit 1
    fi
    echo "Successfully built ${full_image_name}"
    
    echo "Pushing ${full_image_name}..."
    docker push ${full_image_name}
    if [ $? -ne 0 ]; then
        echo "Failed to push ${full_image_name}"
        exit 1
    fi
    echo "Successfully pushed ${full_image_name}"
done
