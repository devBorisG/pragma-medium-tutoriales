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

## Windows (Git Bash y Podman)

Los scripts son de Bash: en Windows ejecútalos desde **Git Bash** (viene con [Git for Windows](https://git-scm.com/download/win)), no desde CMD ni PowerShell.

1. **Podman.** Instala Podman Desktop o `winget install RedHat.Podman`, y luego crea la máquina virtual:
   ```bash
   podman machine init --rootful --cpus 4 --memory 6144
   podman machine start
   podman info                      # debe responder sin error
   ```
   `--rootful` es necesario para que kind pueda crear el clúster.
2. **Herramientas.** `winget install Kubernetes.kind Kubernetes.kubectl Helm.Helm Hashicorp.Terraform` (Terraform solo es opcional). Cierra y vuelve a abrir Git Bash para que tome el PATH.
3. **Podman en lugar de Docker.** En cada sesión de Git Bash:
   ```bash
   export KIND_EXPERIMENTAL_PROVIDER=podman   # kind usa Podman (carpeta 01)
   export DOCKER=podman                       # los scripts usan Podman (carpeta 09)
   ```
4. **Scripts.** Si `./script.sh` no se ejecuta, usa `bash script.sh`. El repo incluye `.gitattributes` para que los `.sh` conserven finales de línea LF; si el clon los trae con CRLF verás `\r: command not found`. Corrígelo con `git config core.autocrlf false` y vuelve a clonar.
5. **Rutas.** Git Bash reescribe argumentos que parecen rutas de Unix (por ejemplo `/CN=...`). Los scripts ya lo evitan con `MSYS_NO_PATHCONV=1`; si ejecutas comandos propios con rutas como `-v /tmp:/tmp`, antepón `MSYS_NO_PATHCONV=1`.
6. **Sin Docker Desktop:** no lo necesitas; Podman cubre ambos tutoriales.

> Los pasos de Windows no se han ejecutado en una máquina Windows limpia por quien escribió el tutorial. Si algo falla, abre un issue con el mensaje exacto.

## Licencia

MIT. Los ejemplos son didácticos y no contienen código ni datos de ningún cliente.
