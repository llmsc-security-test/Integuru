#!/bin/bash
set -e

echo "Starting Integuru AI agent..."

cd /app

# Check if OPENAI_API_KEY is set
if [ -n "$OPENAI_API_KEY" ]; then
    echo "OpenAI API key found, running full integuru agent..."
    if [ $# -eq 0 ]; then
        exec integuru --prompt "Hello, this is a test prompt for Integuru AI."
    else
        exec integuru "$@"
    fi
else
    echo "No OPENAI_API_KEY set, starting basic HTTP server for health checks..."
    # Start a simple HTTP server on port 11070 for health checking
    exec python -m http.server 11070
fi
