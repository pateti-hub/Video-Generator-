Deploy Wan2GP on Google Colab (free demo)
========================================

Short summary
-------------
This guide shows how to run a Wan2GP/Gradio inference server on a free Google Colab GPU instance and expose it with `localtunnel` so your app (or desktop client) can call it. It's intended as a short-lived free demo — Colab sessions are ephemeral (≈12 hours) and public tunnels are unreliable for production.

Limitations
-----------
- Colab sessions time out and may be reclaimed. Not suitable for production or persistent public APIs.
- Models are large; you must either download a model inside Colab each run or mount Google Drive to persist weights.
- Public tunneling (localtunnel/ngrok) is fragile and may require an account for stable usage.

Overview of steps
-----------------
1. Open a new Google Colab notebook and set the Runtime → Change runtime type → Hardware accelerator: `GPU`.
2. Copy-paste the shell commands below into a Colab code cell and run.
3. Wait for the server to start; note the public URL from `lt` (localtunnel).
4. In the desktop app or dev Next.js instance, point the Wan2GP/Gradio server URL to the public URL from Colab.

Quick paste script (run in a Colab cell)
---------------------------------------
This is a minimal script. Customize model downloads and options as needed.

```bash
# Install system deps
apt-get update -y && apt-get install -y git wget python3-pip ffmpeg

# Use Python env inside Colab
python3 -m pip install --upgrade pip

# Clone Wan2GP (or your preferred server). Replace with sd-webui if you prefer.
git clone https://github.com/deepbeepmeep/Wan2GP.git
cd Wan2GP

# Install python requirements (may take a minute)
pip install -r requirements.txt || true

# OPTIONAL: mount Google Drive to persist models between sessions
# from google.colab import drive
# drive.mount('/content/drive')

# NOTE: You must provide or download model weights. Example: place weights in ./models
# Start the server (adjust args per repo docs)
python wgp.py --listen --server-name 0.0.0.0 --port 7860 &

# Install localtunnel (no account required). Alternatives: ngrok (requires token)
npm install -g localtunnel

# Open a public tunnel to the Gradio/Wan2GP port
lt --port 7860 --subdomain my-wan2gp-demo

```

How to connect the app
----------------------
- Desktop app: open Settings → Local Models → Wan2GP server and paste the public URL (e.g., `https://my-wan2gp-demo.loca.lt`). Click Test.
- Dev Next.js / hosted web app: the repo wasn't built to call arbitrary Wan2GP servers from the browser by default. The easiest way is to run the desktop app and point it at the Colab URL.

Persisting models
-----------------
Download model weights into Google Drive and mount the drive in Colab to avoid re-downloading on each session:

```python
from google.colab import drive
drive.mount('/content/drive')
# then place weights under /content/drive/MyDrive/wan2gp-models and symlink into ./models
```

Security notes
--------------
- The public tunnel exposes the Colab instance to anyone with the URL. Do not expose private keys or sensitive data.
- Rate limits and quota: free Colab is intended for experimentation, not heavy usage.

Next steps I can do for you
--------------------------
- Create a runnable Colab notebook file in the repo that users can open directly (I can add a `.ipynb`).
- Add a short script that mounts Google Drive and auto-downloads a sample small model.
- Prepare a short demo video showing the flow.
