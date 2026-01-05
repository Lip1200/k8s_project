# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build stage with JDK
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Copy gradle wrapper and config first (better caching)
COPY gradlew gradlew.bat settings.gradle build.gradle ./
COPY gradle ./gradle

# Ensure gradlew is executable and download dependencies
RUN chmod +x gradlew && ./gradlew downloadRepos --no-daemon

# Copy source code
COPY . .

# Ensure gradlew is still executable after COPY and build
RUN chmod +x gradlew && ./gradlew installDist --no-daemon

# Runtime stage with JRE only
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy built application from builder
COPY --from=builder /app/build/install/hipstershop ./

# Run as non-root user
RUN adduser -D -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

ENV PORT=9555

EXPOSE 9555

ENTRYPOINT ["/app/bin/AdService"]
