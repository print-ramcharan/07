#!/usr/bin/env bash
set -euo pipefail
if ! command -v docker >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y docker.io
fi
sudo systemctl enable --now docker
DOCKER=(docker)
if ! docker info >/dev/null 2>&1; then DOCKER=(sudo docker); fi
"${DOCKER[@]}" build -t devops-static-site:v1 .
"${DOCKER[@]}" rm -f devops-static-site >/dev/null 2>&1 || true
"${DOCKER[@]}" run -d --name devops-static-site -p 8087:80 devops-static-site:v1
sleep 2
curl -fsS http://localhost:8087
echo
echo "RESULT: Dockerfile website deployed at http://localhost:8087"
echo "Container remains running as devops-static-site."
