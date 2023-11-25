#!/bin/bash

# Script name: gitraw-server.sh
# Description: This script creates a Dockerfile for a Python server that echoes
# back the details of received HTTP requests, builds a Docker image from it,
# and runs the container on port 8000. It also prints the public IP of the host
# and makes a test request to the server.

# Set the name of the Docker image
IMAGE_NAME="gitraw-server-image"

# Create a Dockerfile
cat > Dockerfile << EOF
# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "./app.py"]
EOF

# Create a sample app.py (Python server that echoes back received requests)
cat > app.py << EOF
from http.server import BaseHTTPRequestHandler, HTTPServer
import json

class RawHTTPRequestHandler(BaseHTTPRequestHandler):
    def handle(self):
        # Attempt to capture the raw request
        self.raw_requestline = self.rfile.readline()
        if not self.parse_request():
            return

        # Convert raw request line to string and print it
        raw_request_str = self.raw_requestline.decode('utf-8')
        print("Raw Request Line:", raw_request_str)

        # Call the appropriate do_METHOD according to the request
        try:
            if self.command:
                method = getattr(self, 'do_' + self.command)
                method()
            else:
                self.send_error(501, "Unsupported method (%r)" % self.command)
        except Exception as e:
            self.send_error(500, str(e))

    def do_GET(self):
        # Send a response echoing back the raw request line
        self.send_response(200)
        self.end_headers()
        response_content = "Received and echoed: " + self.raw_requestline.decode('utf-8')
        self.wfile.write(response_content.encode())

httpd = HTTPServer(('0.0.0.0', 8000), RawHTTPRequestHandler)
httpd.serve_forever()
EOF

# Create a sample requirements.txt (if any libraries are required)
echo "" > requirements.txt

# Build the Docker image
docker build -t $IMAGE_NAME .

# Run the Docker container in the background, mapping port 8000 of the container to port 8000 of the host
docker run -d -p 8000:8000 $IMAGE_NAME

# Wait for a few seconds to ensure the server is up
sleep 5

# Print the public IP address of the host
echo "Public IP of the host:"
PUBLIC_IP=$(curl -s https://ipinfo.io/ip)
echo $PUBLIC_IP
echo

