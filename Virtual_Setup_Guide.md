# Virtual Setup Guide
## AI Automation for Sales and Customer Care
### F24-160 | FAST-NUCES Lahore | Final Year Project

---

> **Version:** 1.0  
> **Authors:** FYP Team — F24-160  
> **Institution:** FAST National University of Computer and Emerging Sciences, Lahore  
> **Date:** July 2026  

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [System Requirements](#2-system-requirements)
3. [External Services Required](#3-external-services-required)
4. [Environment Configuration](#4-environment-configuration)
5. [Option A — Local Bare-Metal Setup](#5-option-a--local-bare-metal-setup)
6. [Option B — Docker Compose Setup](#6-option-b--docker-compose-setup)
7. [Option C — Kubernetes Setup](#7-option-c--kubernetes-setup)
8. [Verification Checklist](#8-verification-checklist)
9. [Troubleshooting](#9-troubleshooting)
10. [Security Reminders](#10-security-reminders)

---

## 1. Project Overview

This system is a full-stack AI-powered sales automation platform consisting of five microservices:

```
┌──────────────────────────────────────────────────────────┐
│                  Next.js Frontend :3000                   │
│           (Vercel in production / Docker locally)         │
└──────┬──────────────┬─────────────┬──────────────┬────────┘
       │              │             │              │
       ▼              ▼             ▼              ▼
  auth :2000    crm :5000   reporting :6000   sales :8000
  FastAPI        FastAPI       FastAPI       Flask + FastAPI
       │              │                           │
       │    ┌──────────┤               ┌──────────┤
       │    │  Celery worker            │  Celery worker
       │    │                          │
       └────┴──────────────────────────┘
                      │
           ┌──────────┼─────────────┐
           ▼          ▼             ▼
       Supabase     Redis        External APIs
      (Auth+DB)   (Broker)    Groq / Qdrant / Twilio
                               ElevenLabs / Segmind
```

| Service | Port | Role |
|---------|------|------|
| `auth-service` | 2000 | Signup, login, Supabase Auth, JWT management |
| `crm_integration_service` | 5000 | CSV ingestion, column mapping, lead storage |
| `reporting_service` | 6000 | CSV analytics, RAG chat (Qdrant + Groq) |
| `sales_agent_service` | 8000 | LangGraph sales agent, voice calls, ElevenLabs TTS |
| Redis | 6379 | Celery broker/backend for CRM and sales workers |

---

## 2. System Requirements

### Minimum Requirements (Local Bare-Metal)

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Windows 10/11, macOS 12+, Ubuntu 20.04+ | Windows 11 / Ubuntu 22.04 |
| RAM | 8 GB | 16 GB |
| CPU | 4 cores | 8 cores |
| Disk | 10 GB free | 20 GB free |
| Python | 3.12+ | 3.12 |
| Node.js | 20+ | 20 LTS |
| Docker | Desktop 4.x (optional) | Docker Desktop 4.30+ |

### Required Software

#### Python 3.12+
Download from [python.org/downloads](https://www.python.org/downloads/)

```powershell
# Verify installation
python --version    # Should show Python 3.12.x
```

#### Node.js 20+
Download from [nodejs.org](https://nodejs.org/)

```powershell
# Verify installation
node --version      # Should show v20.x.x or higher
npm --version
```

#### Redis (for local development)
Run with Docker (easiest method on any OS):

```powershell
docker run -d -p 6379:6379 --name fyp_redis redis:7-alpine
```

Or install natively on Windows using WSL:

```bash
# In WSL terminal
sudo apt-get install redis-server
sudo service redis-server start
```

#### Docker Desktop (for Options B and C)
Download from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)

> **Windows users:** Enable the WSL2 backend in Docker Desktop settings.

---

## 3. External Services Required

You must create accounts and obtain API keys for the following services:

| Service | Free Tier | Purpose | Sign Up URL |
|---------|-----------|---------|------------|
| **Supabase** | ✅ Yes | PostgreSQL database + Auth | [supabase.com](https://supabase.com) |
| **Groq** | ✅ Yes (rate-limited) | LLM for all AI features | [console.groq.com](https://console.groq.com) |
| **Qdrant Cloud** | ✅ Yes | Vector store for RAG | [cloud.qdrant.io](https://cloud.qdrant.io) |
| **Segmind** | ✅ Yes (credits) | Text embeddings | [segmind.com](https://segmind.com) |
| **Twilio** | 💲 Trial ($15 credit) | Outbound voice calls | [twilio.com](https://twilio.com) |
| **ElevenLabs** | ✅ Yes (limited) | Text-to-speech (TTS) | [elevenlabs.io](https://elevenlabs.io) |
| **Gmail SMTP** | ✅ Yes | Sales email alerts | Google Account Settings |
| **ngrok** | ✅ Yes | Twilio webhooks (local dev) | [ngrok.com](https://ngrok.com) |

> **Minimum to get the UI running:** Supabase + Groq only.

### Setting up Supabase

1. Go to [supabase.com](https://supabase.com) → **New project**
2. Note down your database password (needed for `PSQL_URL`)
3. Wait ~2 minutes for provisioning
4. Go to **Settings → API** and copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon public key** → `SUPABASE_KEY`
   - **service_role key** (click Reveal) → `SERVICE_ROLE`
5. Go to **Settings → Database → Connection string → URI** → copy as `PSQL_URL`

### Applying the Database Schema

1. Open **Supabase Dashboard → SQL Editor → New query**
2. Open `backend/docs/supabase_schema.sql`, paste all contents, click **Run**
3. Verify `users`, `Mapped_Dataset`, and `users_data` appear in Table Editor

### Setting up Groq

1. Go to [console.groq.com](https://console.groq.com)
2. Create a free account
3. Go to **API Keys → Create API Key**
4. Copy the key as `GROQ_API_KEY`

---

## 4. Environment Configuration

The project uses exactly **2 environment files**.

### File 1 — `backend/.env` (all 4 backend services)

```powershell
# Windows PowerShell — from project root
notepad backend\.env
```

Fill in the following values:

```env
# ================================================================
# FYP_SALES — Backend Environment
# ================================================================

# ---- Supabase ----
SUPABASE_URL=https://<your-project>.supabase.co
SUPABASE_KEY=<your-anon-public-key>
supabase_url=https://<your-project>.supabase.co
supabase_key=<your-anon-public-key>
SERVICE_ROLE=<your-service-role-key>
PSQL_URL=postgresql://postgres:<url-encoded-password>@db.<project>.supabase.co:5432/postgres

# ---- Auth service ----
encryption_key=<generate-below>
secret_key=<generate-below>
algorithm=HS256
access_token_expire_minutes=30

# ---- Groq ----
GROQ_API_KEY=<your-groq-api-key>
LLM_MODEL=llama-3.3-70b-versatile

# ---- Redis ----
REDIS_URL=redis://localhost:6379/0

# ---- Reporting ----
QDRANT_CLUSTER_URL=https://<your-cluster>.qdrant.io
QDRANT_API_KEY=<your-qdrant-api-key>
SEGMIND_API_KEY=<your-segmind-api-key>
MEM0_API_KEY=placeholder_not_used
MAX_FILE_SIZE_MB=50

# ---- Sales agent email ----
EMAIL_USER=<your-gmail>@gmail.com
EMAIL_PASS=<your-app-password>

# ---- Twilio (for voice calls) ----
Twilio_ACCOUNT_SID=<your-account-sid>
Twilio_AUTH_TOKEN=<your-auth-token>
TWILIO_NUMBER=<your-twilio-number>

# ---- ElevenLabs (for voice TTS) ----
eleven_labs_key=<your-elevenlabs-key>

# ---- ngrok (for local voice testing) ----
PUBLIC_URL=https://<your-ngrok-url>.ngrok-free.app
ELEVENLABS_AGENT_ID=<your-agent-id>

# ---- Voice LLM ----
VOICE_USE_LANGGRAPH=0
VOICE_LLM_MODEL=llama-3.1-8b-instant
```

#### Generate Required Keys

```powershell
# Generate encryption_key (Fernet) — run once, paste output into .env
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

# Generate secret_key (JWT) — run once, paste output into .env
python -c "import secrets; print(secrets.token_hex(32))"
```

#### Reporting Service Extra Step (Local dev only)

```powershell
# The reporting service reads .env from its working directory
Copy-Item backend\.env backend\reporting_service\app\.env
```

> For Docker and Kubernetes this step is **not needed** — env vars are injected directly.

### File 2 — `frontend/.env.local` (Next.js)

```powershell
notepad frontend\.env.local
```

Set at minimum:

```env
NEXT_PUBLIC_API_BASE_URL=http://localhost:5000
```

#### Hardcoded URL Overrides (Local Dev Only)

The following URLs are currently hardcoded in the frontend source. For local dev, update them:

| File | Change from | Change to |
|------|-------------|-----------|
| `frontend/app/login/page.tsx` | `https://auth-servive.onrender.com` | `http://localhost:2000` |
| `frontend/app/signup/page.tsx` | `https://auth-servive.onrender.com` | `http://localhost:2000` |
| `frontend/lib/apis/reportingApis.ts` | `https://reporting-service-fbj2.onrender.com/api/v1` | `http://localhost:6000/api/v1` |
| `frontend/app/reporting/page.tsx` | `https://reporting-service-fbj2.onrender.com/api/v1` | `http://localhost:6000/api/v1` |

---

## 5. Option A — Local Bare-Metal Setup

Run each service natively in separate terminals. Best for debugging individual services.

### Prerequisites

- Python 3.12+ installed  
- Node.js 20+ installed  
- Redis running (via Docker or WSL)

### Step 1: Start Redis

```powershell
docker run -d -p 6379:6379 --name fyp_redis redis:7-alpine
```

### Step 2: Auth Service (Port 2000)

Open a new PowerShell window:

```powershell
cd backend\auth-service
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 2000
```

### Step 3: CRM Integration Service (Port 5000)

Open a new PowerShell window:

```powershell
cd backend\crm_integration_service
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.api.main:app --reload --port 5000
```

CRM Celery Worker (another new window):

```powershell
cd backend\crm_integration_service
.\.venv\Scripts\activate
celery -A app.worker.celery_app worker --loglevel=info -P solo
```

> **Windows note:** Use `-P solo` if gevent causes issues.

### Step 4: Reporting Service (Port 6000)

Open a new PowerShell window:

```powershell
cd backend\reporting_service
python -m venv .venv
.\.venv\Scripts\activate
pip install -r app\requirements.txt
cd app
uvicorn main:app --reload --port 6000
```

### Step 5: Sales Agent Service (Port 8000)

Open a new PowerShell window:

```powershell
cd backend\sales_agent_service
python -m venv .venv
.\.venv\Scripts\activate
pip install -r src\requirements.txt
python -m src.calling_agent.main
```

For voice calls — run ngrok and update `PUBLIC_URL`:

```powershell
ngrok http 8000
# Copy the https://xxxx.ngrok-free.app URL into backend/.env as PUBLIC_URL
# Then restart the sales service
```

### Step 6: Frontend (Port 3000)

Open a new PowerShell window:

```powershell
cd frontend
npm install
npm run dev
# → Open http://localhost:3000 in your browser
```

### Quick-Start Script (All at Once)

From inside the `backend/` folder, run:

```powershell
.\run_local.ps1
```

This opens 6 separate PowerShell windows automatically.

### All Terminals at a Glance

| Terminal | Directory | Command | Port |
|----------|-----------|---------|------|
| 1 | — | `docker run -d -p 6379:6379 redis:7-alpine` | 6379 |
| 2 | `backend/auth-service` | `uvicorn app.main:app --reload --port 2000` | 2000 |
| 3 | `backend/crm_integration_service` | `uvicorn app.api.main:app --reload --port 5000` | 5000 |
| 4 | `backend/crm_integration_service` | `celery -A app.worker.celery_app worker -P solo` | — |
| 5 | `backend/reporting_service/app` | `uvicorn main:app --reload --port 6000` | 6000 |
| 6 | `backend/sales_agent_service` | `python -m src.calling_agent.main` | 8000 |
| 7 | `frontend` | `npm run dev` | 3000 |

---

## 6. Option B — Docker Compose Setup

Runs all services in containers with a single command. **Recommended for integration testing.**

### Prerequisites

- Docker Desktop installed and running
- WSL2 backend enabled (Windows)

### Step 1: Fill in Environment Files

```powershell
notepad backend\.env           # fill in all credentials
notepad frontend\.env.local    # set NEXT_PUBLIC_API_BASE_URL
```

> All backend services share `backend/.env` via `env_file` in docker-compose.  
> `REDIS_URL` is automatically overridden to `redis://redis:6379/0` for Docker networking.

### Step 2: Build and Start

```powershell
# From the project root (fyp_test/)
docker compose -f backend\docker-compose.yml up --build

# Or run detached (background):
docker compose -f backend\docker-compose.yml up --build -d
```

> First build takes **5–10 minutes** (downloads Python/Node base images and installs packages).

### Step 3: Access the Application

| URL | Service |
|-----|---------|
| http://localhost:3000 | Frontend (main app) |
| http://localhost:2000/docs | Auth Service API docs |
| http://localhost:5000/docs | CRM API docs |
| http://localhost:6000/docs | Reporting API docs |
| http://localhost:8000 | Sales Agent demo |

### Useful Docker Compose Commands

```powershell
# Tail logs for a service
docker compose logs -f auth
docker compose logs -f crm
docker compose logs -f crm-worker
docker compose logs -f reporting
docker compose logs -f sales
docker compose logs -f frontend

# Rebuild and restart a single service after a code change
docker compose up --build auth -d

# Start only backend (skip frontend for API testing)
docker compose up redis auth crm crm-worker reporting sales sales-worker -d

# Open a shell in a running container
docker compose exec crm bash
docker compose exec frontend sh

# Stop all containers
docker compose down

# Stop and wipe Redis volume
docker compose down -v
```

---

## 7. Option C — Kubernetes Setup

Uses Docker images deployed to a Kubernetes cluster. Matches the FYP's production deployment intent.

```
Docker builds images  →  Push to registry  →  Kubernetes pulls & orchestrates
```

### Prerequisites

- Docker Desktop (running)
- minikube (for local K8s)
- kubectl

```powershell
winget install Kubernetes.minikube
winget install Kubernetes.kubectl
```

### Local Kubernetes with minikube

#### 1. Start minikube

```powershell
minikube start --driver=docker --memory=6144 --cpus=4
minikube status    # Should show: Host: Running, kubelet: Running, apiserver: Running
```

#### 2. Point Docker CLI at minikube's daemon

```powershell
# Run this in EVERY terminal where you build images
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

#### 3. Build all Docker images into minikube

```powershell
docker build -t fyp/auth-service:latest         backend\auth-service
docker build -t fyp/crm-service:latest          backend\crm_integration_service
docker build -t fyp/reporting-service:latest    backend\reporting_service
docker build -t fyp/sales-agent-service:latest  backend\sales_agent_service
docker build -t fyp/frontend:latest             frontend
```

#### 4. Create the Kubernetes Secret from backend/.env

```powershell
# Apply namespace first
kubectl apply -f backend\k8s\00-namespace.yaml

# Create secret directly from backend/.env
kubectl create secret generic backend-secret `
  --from-env-file=./backend/.env `
  -n fyp `
  --dry-run=client -o yaml | kubectl apply -f -
```

#### 5. Apply all Kubernetes manifests

```powershell
kubectl apply -f backend\k8s\00-namespace.yaml
kubectl apply -f backend\k8s\02-configmap.yaml
kubectl apply -f backend\k8s\03-redis.yaml
kubectl apply -f backend\k8s\04-auth.yaml
kubectl apply -f backend\k8s\05-crm.yaml
kubectl apply -f backend\k8s\06-reporting.yaml
kubectl apply -f backend\k8s\07-sales.yaml
kubectl apply -f backend\k8s\08-frontend.yaml

# Watch pods come up
kubectl get pods -n fyp -w
```

All pods should reach `Running` status within 2–3 minutes.

#### 6. Access Services

```powershell
# Open frontend in browser
minikube service frontend -n fyp

# Or port-forward manually
kubectl port-forward svc/frontend   3000:3000 -n fyp
kubectl port-forward svc/auth       2000:2000 -n fyp
kubectl port-forward svc/crm        5000:5000 -n fyp
kubectl port-forward svc/reporting  6000:6000 -n fyp
kubectl port-forward svc/sales      8000:8000 -n fyp
```

#### 7. Enable Ingress (optional)

```powershell
minikube addons enable ingress

# Edit backend/k8s/09-ingress.yaml — replace "yourdomain.com" with e.g. "fyp.local"
kubectl apply -f backend\k8s\09-ingress.yaml

# Run tunnel (keep this terminal open; may need admin)
minikube tunnel

# Add to C:\Windows\System32\drivers\etc\hosts:
# 127.0.0.1  fyp.local
# Then browse to http://fyp.local
```

### Production Kubernetes (GKE / EKS / AKS)

#### 1. Build and push images to a container registry

```powershell
$REGISTRY = "docker.io/yourusername"

docker build -t $REGISTRY/fyp-auth:latest         backend\auth-service
docker build -t $REGISTRY/fyp-crm:latest          backend\crm_integration_service
docker build -t $REGISTRY/fyp-reporting:latest    backend\reporting_service
docker build -t $REGISTRY/fyp-sales:latest        backend\sales_agent_service
docker build -t $REGISTRY/fyp-frontend:latest     frontend

docker push $REGISTRY/fyp-auth:latest
docker push $REGISTRY/fyp-crm:latest
docker push $REGISTRY/fyp-reporting:latest
docker push $REGISTRY/fyp-sales:latest
docker push $REGISTRY/fyp-frontend:latest
```

Update the `image:` field in `backend/k8s/04-auth.yaml` through `backend/k8s/08-frontend.yaml`.

#### 2. Point kubectl at your cluster

```powershell
# GKE:
gcloud container clusters get-credentials <cluster-name> --region <region>

# EKS:
aws eks update-kubeconfig --name <cluster-name> --region <region>

# AKS:
az aks get-credentials --resource-group <rg> --name <cluster-name>
```

#### 3. Create the secret and deploy

```powershell
kubectl apply -f backend\k8s\00-namespace.yaml

kubectl create secret generic backend-secret `
  --from-env-file=./backend/.env `
  -n fyp `
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f backend\k8s\
```

---

## 8. Verification Checklist

### Quick Health Check (After Any Deployment)

```powershell
# Each should return HTTP 200 or a JSON body
Invoke-WebRequest http://localhost:2000/docs    # auth swagger
Invoke-WebRequest http://localhost:5000/docs    # crm swagger
Invoke-WebRequest http://localhost:6000/health  # reporting health
Invoke-WebRequest http://localhost:8000         # sales
Invoke-WebRequest http://localhost:3000         # frontend
```

### Application Walkthrough Checklist

```
[ ] http://localhost:3000           Landing page loads
[ ] http://localhost:3000/signup    Can create an account
[ ] http://localhost:3000/login     Can log in
[ ] http://localhost:3000/crm-integration   Upload CSV → mapped data appears
[ ] http://localhost:3000/dashboard         Contacts table shows rows
[ ] http://localhost:3000/sales-agent       Start processing works
[ ] http://localhost:3000/reporting         CSV analysis charts + AI chat work
[ ] http://localhost:3000/voice-demo        Mic → AI response works
```

---

## 9. Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `SUPABASE_URL is None` | `.env` not found or wrong path | Check file at `backend/.env`; for reporting also copy to `backend/reporting_service/app/.env` |
| `Cannot connect to redis://localhost:6379` | Redis not running | `docker run -d -p 6379:6379 redis:7-alpine` |
| Celery worker crashes on Windows | `fork`-based multiprocessing | Add `-P solo` to the celery command |
| `MEM0_API_KEY field required` | Pydantic validation | Set `MEM0_API_KEY=placeholder_not_used` in `.env` |
| `psycopg2.OperationalError` | Wrong `PSQL_URL` | Copy the URI from Supabase → Settings → Database → Connection string |
| `REDIS_URL redis://localhost fails in Docker` | Container uses service name | The `docker-compose.yml` already overrides this — just rebuild |
| Frontend "Network Error" for all API calls | Wrong `NEXT_PUBLIC_API_BASE_URL` | Check `.env.local`; update hardcoded auth/reporting URLs in source |
| Twilio webhook errors | `PUBLIC_URL` not set | Run ngrok, copy URL to `PUBLIC_URL` in `.env`, restart sales service |
| Dashboard shows user `6921` | Auth token not reaching backend | Log in via `/login` properly; `6921` is a hardcoded fallback |
| `psql` DDL error in CRM | Hardcoded password in `helper_function.py` | Replace line 10 in `crm_integration_service/app/api/helper_function.py` with `os.getenv("PSQL_URL")` |

### Useful kubectl Commands (Reference)

```powershell
kubectl get pods -n fyp
kubectl logs -n fyp deployment/auth        -f
kubectl logs -n fyp deployment/crm         -f
kubectl logs -n fyp deployment/crm-worker  -f
kubectl logs -n fyp deployment/reporting   -f
kubectl logs -n fyp deployment/sales       -f
kubectl logs -n fyp deployment/frontend    -f
kubectl describe pod -n fyp <pod-name>
kubectl exec -it -n fyp deployment/crm -- bash
kubectl scale deployment crm-worker   -n fyp --replicas=3
kubectl rollout restart deployment/auth -n fyp
kubectl delete namespace fyp
minikube stop
minikube delete
```

---

## 10. Security Reminders

1. **Rotate the hardcoded DB password** in `crm_integration_service/app/api/helper_function.py` line 10 — go to Supabase → Settings → Database → Reset database password.
2. **Never commit `backend/.env`** — it is listed in `.gitignore`.
3. In production, restrict CORS `allow_origins` from `"*"` to your actual frontend domain.
4. Use `SERVICE_ROLE` only in backend services — never in the browser.
5. For production K8s, use [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) or [External Secrets Operator](https://external-secrets.io/) instead of plain Secrets YAML.

---

*This document was generated for FYP F24-160 — AI Automation for Sales and Customer Care.*  
*FAST-NUCES Lahore | 2026*
