FROM eclipse-temurin:19-jdk

WORKDIR /app

COPY . .

RUN chmod +x gradlew && \
    ./gradlew downloadRepos && \
    ./gradlew installDist --no-daemon

EXPOSE 9555

ENTRYPOINT ["/app/build/install/hipstershop/bin/AdService"]
