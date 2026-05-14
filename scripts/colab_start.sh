#!/bin/bash
set -euo pipefail

echo "Installing system packages and tools..."
apt-get update -y && apt-get install -y git wget python3-pip ffmpeg nodejs npm

echo "Upgrading pip and installing Python deps..."
python3 -m pip install --upgrade pip

echo "Cloning Wan2GP..."
git clone https://github.com/deepbeepmeep/Wan2GP.git || true
cd Wan2GP || exit 1

echo "Installing Python requirements (best-effort)..."
pip install -r requirements.txt || true

echo "NOTE: Place your model weights into ./models or mount Google Drive to persist them."

echo "Starting Wan2GP server in background..."
nohup python wgp.py --listen --server-name 0.0.0.0 --port 7860 > wgp.log 2>&1 &

echo "Installing localtunnel to expose port 7860 publicly..."
npm install -g localtunnel

echo "Starting localtunnel (pick a unique subdomain if available)..."
lt --port 7860 --subdomain my-wan2gp-demo

echo "Done. If localtunnel prints a URL, use it in your client. Tail logs with: tail -f wgp.log"
