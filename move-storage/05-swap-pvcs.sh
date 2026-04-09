#!/bin/bash
set -euo pipefail

NAMESPACE="openreplay"

echo "=== Eliminazione pod migrator ==="
kubectl -n "$NAMESPACE" delete pod data-migrator --ignore-not-found

echo ""
echo "=== Eliminazione vecchi PVC (Longhorn) ==="
kubectl -n "$NAMESPACE" delete pvc minio --ignore-not-found
kubectl -n "$NAMESPACE" delete pvc redis-data-redis-master-0 --ignore-not-found
kubectl -n "$NAMESPACE" delete pvc openreplay-shared-storage --ignore-not-found

echo ""
echo "=== Vecchi PVC eliminati ==="
echo ""
echo "I nuovi PVC CephFS sono:"
kubectl -n "$NAMESPACE" get pvc minio-ceph redis-data-ceph shared-storage-ceph

echo ""
echo "=== PROSSIMI PASSI ==="
echo "1. Pusha le modifiche al chart (storageClass: ceph-dm-cephfs)"
echo "2. Fleet ri-deployerà i workload con i nuovi PVC"
echo "3. Verifica che i pod si avviino correttamente"
