#!/bin/sh

# GitHub Container Registry configuration
REGISTRY="ghcr.io"
GITHUB_USER="lip1200"
PROJECT_NAME="k8s_project"
TAG="latest"

# Check if logged in to ghcr.io
echo "Checking GitHub Container Registry authentication..."
if ! docker info 2>/dev/null | grep -q "ghcr.io"; then
    echo "⚠️  You may need to login to ghcr.io first:"
    echo "   echo \$GITHUB_TOKEN | docker login ghcr.io -u ${GITHUB_USER} --password-stdin"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Define images and their context paths
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

# Build and push all images
for image_context in $images; do
    image_name=$(echo $image_context | cut -d':' -f1)
    context_path=$(echo $image_context | cut -d':' -f2)
    full_image_name="${REGISTRY}/${GITHUB_USER}/${PROJECT_NAME}/${image_name}:${TAG}"
    
    echo ""
    echo "========================================"
    echo "Building ${image_name}..."
    echo "========================================"
    docker build --platform linux/amd64 -t ${full_image_name} ${context_path}
    if [ $? -ne 0 ]; then
        echo "❌ Failed to build ${full_image_name}"
        exit 1
    fi
    echo "✅ Successfully built ${full_image_name}"
    
    echo "Pushing ${full_image_name}..."
    docker push ${full_image_name}
    if [ $? -ne 0 ]; then
        echo "❌ Failed to push ${full_image_name}"
        exit 1
    fi
    echo "✅ Successfully pushed ${full_image_name}"
done

echo ""
echo "========================================"
echo "🎉 All images built and pushed successfully!"
echo "========================================""
