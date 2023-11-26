#!/bin/bash

# Step 1: Create Flask app
cat > app.py <<EOF
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/', methods=['POST'])
def echo():
    return jsonify(request.json)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
EOF

# Step 2: Create Dockerfile
cat > Dockerfile <<EOF
FROM python:3.9-slim
WORKDIR /app
COPY app.py /app
RUN pip install Flask
CMD ["python", "/app/app.py"]
EOF

# Step 3: Check if the container name already exists
if [ $(docker ps -a -q -f name=flask-app) ]; then
    echo "Container 'flask-app' already exists. Removing it..."
    docker stop flask-app
    docker rm flask-app
fi

# Step 4: Build and Run Docker Container
docker build -t flask-app .
docker run -d -p 8000:8000 --name flask-app flask-app

# Optional Step 5: Test the setup using curl
echo "To test, run: curl -X POST -d '{\"key\":\"value\"}' -H 'Content-Type: application/json' http://localhost:8000/"

