# Dockerfile for Integuru-AI--Integuru
# Based on Python 3.12-slim (required by the project)

FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv for running the application (installs to ~/.local/bin)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    ln -sf /root/.local/bin/uv /usr/local/bin/uv && \
    ln -sf /root/.local/bin/uvx /usr/local/bin/uvx

# Copy the entire project first
COPY . .

# Install dependencies using poetry
RUN pip install --no-cache-dir poetry && \
    poetry build -f wheel && \
    pip install --no-cache-dir dist/*.whl

# Remove the problematic directories that were incorrectly created
RUN rm -rf /app/network_requests.har /app/cookies.json

# Create a minimal valid HAR file (HTTP Archive format)
RUN echo '{"log":{"version":"1.2","entries":[]}}' > /app/network_requests.har

# Create an empty cookies.json file
RUN echo '[]' > /app/cookies.json

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port (for potential web interface)
EXPOSE 11070

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
