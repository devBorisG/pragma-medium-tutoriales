terraform {
  required_version = ">= 1.6"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"   # la sintaxis de bloques "set" es la de la v2
    }
  }
}

variable "kube_context" {
  type    = string
  default = "kind-argo-demo"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.kube_context
  }
}

resource "helm_release" "argo_workflows" {
  name             = "argo-workflows"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-workflows"
  namespace        = "argo"
  create_namespace = true
  version          = "0.45.3"
  atomic           = true

  set {
    name  = "workflow.serviceAccount.create"
    value = "true"
  }
  set {
    name  = "workflow.serviceAccount.name"
    value = "argo-workflow"
  }
  set {
    name  = "workflow.rbac.create"
    value = "true"
  }

  # Borra cada pod cuando termina (éxito o fallo)
  set {
    name  = "controller.workflowDefaults.spec.podGC.strategy"
    value = "OnPodCompletion"
  }
  # ...pero espera 10 minutos antes de borrarlo, para poder leer sus logs
  set {
    name  = "controller.workflowDefaults.spec.podGC.deleteDelayDuration"
    value = "600s"
  }
  # TTL del objeto Workflow en el API server
  set {
    name  = "controller.workflowDefaults.spec.ttlStrategy.secondsAfterCompletion"
    value = "3600"
  }
  set {
    name  = "controller.workflowDefaults.spec.ttlStrategy.secondsAfterSuccess"
    value = "1800"
  }
  set {
    name  = "controller.workflowDefaults.spec.ttlStrategy.secondsAfterFailure"
    value = "86400"
  }
}
