FROM eclipse-temurin:22-jdk-alpine

WORKDIR /app

COPY . .

RUN chmod +x gradlew && \
    ./gradlew downloadRepos && \
    ./gradlew installDist

EXPOSE 9555
ENTRYPOINT ["/app/build/install/hipstershop/bin/AdService"]
