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

FROM python:3.12-slim AS base

FROM base AS builder

RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        wget g++ \
    && rm -rf /var/lib/apt/lists/*

# Install packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM base

# Enable unbuffered logging
ENV PYTHONUNBUFFERED=1

WORKDIR /emailservice

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.12/ /usr/local/lib/python3.12/

# Copy application files
COPY . .

# Run as non-root user
RUN useradd -r -u 1000 appuser && chown -R appuser:appuser /emailservice
USER appuser

ENV PORT=5000

EXPOSE 5000

ENTRYPOINT ["python", "email_server.py"]
