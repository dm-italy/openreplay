# Migrazione Storage: Longhorn -> CephFS (ceph-dm-cephfs)

## Ordine di esecuzione

1. **Scale down** — ferma i workload
   ```bash
   kubectl -n openreplay scale deploy minio --replicas=0
   kubectl -n openreplay scale sts redis-master --replicas=0
   ```

2. **Crea i nuovi PVC** su CephFS
   ```bash
   kubectl apply -f 02-new-pvcs.yaml
   ```

3. **Avvia il pod migrator**
   ```bash
   kubectl apply -f 03-migrator-pod.yaml
   ```

4. **Copia i dati**
   ```bash
   bash 04-copy-data.sh
   ```

5. **Swap PVC** — elimina vecchi PVC e pod migrator
   ```bash
   bash 05-swap-pvcs.sh
   ```

6. **Push chart aggiornato** — Fleet ri-deployerà con `ceph-dm-cephfs`

7. **Verifica** che tutti i pod siano running e i dati siano integri
