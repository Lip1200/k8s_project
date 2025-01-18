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

FROM golang:1.22.4-alpine AS builder

WORKDIR /src

# Restore dependencies first (better caching)
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux go build -o /frontend .

# Final minimal image
FROM alpine:3.19

# Add CA certificates for HTTPS calls
RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copy binary from builder
COPY --from=builder /frontend ./frontend

# Copy static files and templates
COPY --from=builder /src/static ./static
COPY --from=builder /src/templates ./templates

# Run as non-root user
RUN adduser -D -u 1000 appuser
USER appuser

ENV GOTRACEBACK=single

EXPOSE 8080
ENTRYPOINT ["./frontend"]
