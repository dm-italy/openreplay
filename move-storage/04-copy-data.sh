#!/bin/bash
set -euo pipefail

NAMESPACE="openreplay"
POD="data-migrator"

echo "=== Attesa pod data-migrator ready ==="
kubectl -n "$NAMESPACE" wait --for=condition=Ready pod/"$POD" --timeout=120s

echo ""
echo "=== Copia dati MinIO ==="
kubectl -n "$NAMESPACE" exec "$POD" -- sh -c "cp -av /old/minio/. /new/minio/"

echo ""
echo "=== Copia dati Redis ==="
kubectl -n "$NAMESPACE" exec "$POD" -- sh -c "cp -av /old/redis/. /new/redis/"

echo ""
echo "=== Copia dati Shared Storage ==="
kubectl -n "$NAMESPACE" exec "$POD" -- sh -c "cp -av /old/shared/. /new/shared/"

echo ""
echo "=== Verifica dimensioni ==="
kubectl -n "$NAMESPACE" exec "$POD" -- sh -c "
echo '--- MinIO ---'
du -sh /old/minio /new/minio
echo '--- Redis ---'
du -sh /old/redis /new/redis
echo '--- Shared ---'
du -sh /old/shared /new/shared
"

echo ""
echo "=== Copia completata. Verifica le dimensioni sopra prima di procedere ==="
