Railway Deployment Guide
=======================

Overview
--------
This project can run on Railway as a standard Next.js app. For cloud generation the app proxies requests to Muapi.ai, so you can:

- Let each browser user paste their own Muapi API key (default UI flow — no server changes), or
- Configure a single server-side `MUAPI_KEY` env var to use a shared account (convenient but costs money and is less secure).

Important notes
---------------
- Railway (and most PaaS) do not provide GPUs — local/desktop inference engines (sd.cpp, Wan2GP with attached GPU) cannot be used on Railway. Use Muapi.ai cloud endpoints for inference when hosted on Railway.
- Using a shared `MUAPI_KEY` means every user of your hosted site will consume credits from that account. Protect the key and monitor usage.

Environment variables
---------------------
- `MUAPI_KEY` (optional): a Muapi API key for server-side fallback. If not set, the server will rely on `x-api-key` header or `muapi_key` cookie provided by the browser UI.
- `MUAPI_BASE` (optional): override Muapi base URL (defaults to `https://api.muapi.ai`).

Railway deployment steps
------------------------
1. Create a new Railway project and choose "Deploy from GitHub".
2. Connect the `Anil-matcha/Open-Generative-AI` repository and pick the `main` branch.
3. In Railway project settings → Variables, add any of these you need:

   - `MUAPI_KEY` = your Muapi API key (optional — only if you want a shared server key)
   - `MUAPI_BASE` = https://api.muapi.ai (optional)

4. Railway will detect the project and run the default `npm install` and `npm run build`. If it does not, set the Build Command to:

```
npm ci && npm run build
```

and the Start Command to:

```
npm run start
```

5. After deployment, point your browser to the Railway-provided URL. If you did not set a shared `MUAPI_KEY`, users will be prompted to paste their Muapi API key in the UI.

Security & cost recommendations
-------------------------------
- Prefer letting users supply their own keys (default flow) to avoid unexpected bill spikes.
- If you must use a shared server key, set usage limits in the Muapi dashboard (if available) and rotate keys periodically.

Troubleshooting
---------------
- Build errors: ensure Node 18+ is used. If Railway builds fail, set `NODE_VERSION` or add an `.nvmrc` with `18`.
- Memory/timeouts: Next.js builds can be memory intensive; consider using Railway Pro or a larger plan for production.

Questions
---------
If you want, I can add a small README section with Railway instructions into `README.md` and/or add an `.env.example` file. Which would you like? 
