#!/bin/sh

set -e

echo "⏳ Initialisation des buckets MinIO..."

# Configuration du client MinIO
mc alias set agomarket http://agomarket-datalake:9000 agomarket agomarket-minio-pwd

# Création des buckets (si non existants)
mc mb -p agomarket/bronze || true
mc mb -p agomarket/silver || true
mc mb -p agomarket/gold || true

echo "✔ Buckets MinIO initialisés : Bronze, Silver, Gold"