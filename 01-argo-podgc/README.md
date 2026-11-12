# 01 · Pods de Argo Workflows que se acumulan: podGC y ttlStrategy

Reproduce el problema en un clúster local y aplica la solución con Helm (o con Terraform).

## Requisitos

- Docker o Podman, [kind](https://kind.sigs.k8s.io/) 0.20+, `kubectl` y Helm 3.
- Opcional: Terraform 1.6+ para la variante con Terraform.

## 1. Clúster y Argo sin garbage collection

```bash
kind create cluster --name argo-demo
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
helm install argo-workflows argo/argo-workflows -n argo --create-namespace \
  --version 0.45.3 -f values-sin-gc.yaml --wait
```

## 2. Reproducir el problema

```bash
kubectl create -f workflow-prueba.yaml
kubectl create -f workflow-prueba.yaml
sleep 60
./verificar.sh
```

**Resultado esperado:** 6 pods en `Succeeded` que nunca se borran y 2 workflows guardados.
Si esperas más, siguen ahí.

## 3. Aplicar la solución (tiempos cortos para la demo)

```bash
helm upgrade argo-workflows argo/argo-workflows -n argo \
  --version 0.45.3 -f values-demo.yaml --wait
kubectl get configmap -n argo -l app.kubernetes.io/component=workflow-controller -o yaml | grep -A 10 workflowDefaults
```

**Resultado esperado:** el ConfigMap del controller muestra `podGC` y `ttlStrategy`.

## 4. Verificar

```bash
kubectl create -f workflow-prueba.yaml
kubectl get pods -n argo -w      # los pods terminan y ~30 s después desaparecen (Ctrl+C para salir)
./verificar.sh                   # a los ~2 minutos, el workflow nuevo también desaparece
```

Los workflows del paso 2 no se limpian solos: se crearon antes de aplicar los defaults.
Límpialos con `kubectl delete workflows -n argo --all`.

## Variante con Terraform

`terraform/main.tf` aplica los valores de producción del tutorial (600 s, 1800 s, 3600 s, 86400 s).
Si ya instalaste con Helm en los pasos anteriores, desinstala primero para no duplicar el release.

```bash
helm uninstall argo-workflows -n argo
cd terraform && terraform init && terraform apply
```

## Limpieza

```bash
kind delete cluster --name argo-demo
```
