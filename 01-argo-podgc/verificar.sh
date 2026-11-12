#!/usr/bin/env sh
# Cuenta pods y workflows del namespace argo por estado
NS=${1:-argo}
echo "Pods por fase en $NS:"
kubectl get pods -n "$NS" --no-headers -o custom-columns=PHASE:.status.phase | sort | uniq -c
echo
echo "Workflows guardados en $NS:"
kubectl get workflows -n "$NS" --no-headers 2>/dev/null | wc -l
