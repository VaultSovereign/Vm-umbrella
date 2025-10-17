# VaultMesh AI — GCP Deployment Guide (Workbench + CLI)

This guide deploys:
- **Workbench** (Fastify BFF + SPA) as a container
- **CLI** image for batch jobs
- Builds via **Cloud Build**, stores images in **Artifact Registry**, runs on **Cloud Run**

> Prereqs: `gcloud` auth; a GCP project with Artifact Registry + Cloud Run APIs enabled.

## 1) One-time setup

```bash
gcloud services enable artifactregistry.googleapis.com run.googleapis.com cloudbuild.googleapis.com
gcloud artifacts repositories create vaultmesh \
  --repository-format=docker --location=us --description="VaultMesh images"
```

## 2) Build & push images (Cloud Build)

`cloudbuild.yaml` already builds workbench and cli images. Run:

```bash
gcloud builds submit \
  --config=cloudbuild.yaml \
  --substitutions=_REGION=us,_REPO=vaultmesh
```

Images land under:
	•	`us-docker.pkg.dev/<PROJECT>/vaultmesh/workbench:<sha>`
	•	`us-docker.pkg.dev/<PROJECT>/vaultmesh/cli:<sha>`

## 3) Deploy Workbench to Cloud Run

SSE note: Cloud Run supports SSE; ensure clients use HTTP/2 and we set `X-Accel-Buffering: no` (already in BFF).

```bash
IMAGE="us-docker.pkg.dev/$(gcloud config get-value project)/vaultmesh/workbench:$(git rev-parse --short HEAD)"

gcloud run deploy vaultmesh-workbench \
  --image="$IMAGE" \
  --region=us-central1 \
  --platform=managed \
  --allow-unauthenticated \
  --port=8787 \
  --set-env-vars="NODE_ENV=production,DEV_NO_AUTH=0" \
  --set-env-vars="CORS_ORIGIN=https://your-domain" \
  --set-env-vars="OPENROUTER_API_KEY=__SET_IN_SECRETS__" \
  --set-env-vars="LEDGER_DIR=/var/ledger" \
  --timeout=900 --memory=1Gi --cpu=1
```

If using Secret Manager, mount provider keys via `--update-secrets` (recommended).

## 4) Verify health & SSE

```bash
curl -fsS https://<run-url>/v1/api/health | jq .
curl -fsSN "https://<run-url>/v1/api/execute/stream?templateId=demo.echo&args=%7B%22message%22%3A%22hi%22%7D" | head -n 10
```

## 5) Security & scaling notes
	•	Auth: enable OIDC; set `DEV_NO_AUTH=0`. Validate JWT in BFF.
	•	SSE: already sets `Cache-Control: no-cache`, `Connection: keep-alive`, retry hints.
	•	Autoscaling: start with `--max-instances=3`, add later as needed.
	•	Ledger: store on a durable volume or forward events to a storage backend (GCS bucket) if desired.