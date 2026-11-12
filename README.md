# Tutoriales Medium: código de ejemplo

Código completo y ejecutable de los tutoriales publicados en Medium bajo la publicación de Pragma.
Cada carpeta es independiente y trae su propio `README.md` con requisitos, pasos y resultado esperado.

| Carpeta | Tutorial | Entorno para probarlo |
|---|---|---|
| [01-argo-podgc](01-argo-podgc) | Pods de Argo Workflows que se comen las IPs de AKS | kind + Helm (local) |
| [09-dockerfile-cacerts](09-dockerfile-cacerts) | Un Dockerfile que encuentra cacerts en cualquier versión de Java | Docker o Podman |

## Herramientas

- Docker o Podman.
- [kind](https://kind.sigs.k8s.io/) 0.20+, `kubectl` y [Helm](https://helm.sh/) 3 (carpeta 01).
- `openssl` (carpeta 09).
- Opcional: Terraform 1.6 o superior para la variante con Terraform de la carpeta 01.

## Licencia

MIT. Los ejemplos son didácticos y no contienen código ni datos de ningún cliente.
