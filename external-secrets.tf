locals {
  external_secrets = merge(
    local.helm_defaults,
    {
      name       = "external-secrets"
      namespace  = "external-secrets"
      chart      = "external-secrets"
      repository = local.helm_repository_external_secrets.name
      create_ns  = false
    },
    var.external_secrets
  )

  values_external_secrets = <<VALUES
image:
  tag: ${local.external_secrets["version"]}
VALUES

}

resource "kubernetes_namespace" "external_secrets" {
  count = local.external_secrets["enabled"] && local.external_secrets["create_ns"] ? 1 : 0

  metadata {
    labels = {
      name = local.external_secrets["namespace"]
    }

    name = local.external_secrets["namespace"]
  }
}

resource "helm_release" "external_secrets" {
  count                 = local.external_secrets["enabled"] ? 1 : 0
  repository            = local.external_secrets["repository"]
  name                  = local.external_secrets["name"]
  chart                 = local.external_secrets["chart"]
  version               = local.external_secrets["chart_version"]
  timeout               = local.external_secrets["timeout"]
  force_update          = local.external_secrets["force_update"]
  recreate_pods         = local.external_secrets["recreate_pods"]
  wait                  = local.external_secrets["wait"]
  atomic                = local.external_secrets["atomic"]
  cleanup_on_fail       = local.external_secrets["cleanup_on_fail"]
  dependency_update     = local.external_secrets["dependency_update"]
  disable_crd_hooks     = local.external_secrets["disable_crd_hooks"]
  disable_webhooks      = local.external_secrets["disable_webhooks"]
  render_subchart_notes = local.external_secrets["render_subchart_notes"]
  replace               = local.external_secrets["replace"]
  reset_values          = local.external_secrets["reset_values"]
  reuse_values          = local.external_secrets["reuse_values"]
  skip_crds             = local.external_secrets["skip_crds"]
  verify                = local.external_secrets["verify"]
  values = [
    local.values_jexternal_secrets,
    local.external_secrets["extra_values"]
  ]
  namespace = local.external_secrets["namespace"]

  depends_on = [
    helm_release.kiam
  ]
}

resource "kubernetes_network_policy" "external_secrets_default_deny" {
  count = local.jenkins_operator["create_ns"] && local.external_secrets["enabled"] && local.external_secrets["default_network_policy"] ? 1 : 0

  metadata {
    name      = "${kubernetes_namespace.external_secrets.*.metadata.0.name[count.index]}-default-deny"
    namespace = kubernetes_namespace.external_secrets.*.metadata.0.name[count.index]
  }

  spec {
    pod_selector {
    }
    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "external_secrets_allow_namespace" {
  count = local.external_secrets["create_ns"] && local.external_secrets["enabled"] && local.external_secrets["default_network_policy"] ? 1 : 0

  metadata {
    name      = "${kubernetes_namespace.external_secrets.*.metadata.0.name[count.index]}-allow-namespace"
    namespace = kubernetes_namespace.external_secrets.*.metadata.0.name[count.index]
  }

  spec {
    pod_selector {
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = kubernetes_namespace.external_secrets.*.metadata.0.name[count.index]
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

