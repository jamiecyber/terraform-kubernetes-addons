locals {
  jenkins_operator = merge(
    local.helm_defaults,
    {
      name       = "jenkins"
      namespace  = "jenkins-operator"
      chart      = "jenkins"
      repository = local.helm_repository_stable.name
      create_ns  = false
    },
    var.jenkins_operator
  )

  values_jenkins = <<VALUES
image:
  tag: ${local.jenkins_operator["version"]}
VALUES

}

resource "kubernetes_namespace" "jenkins_operator" {
  count = local.jenkins_operator["enabled"] && local.jenkins_operator["create_ns"] ? 1 : 0

  metadata {
    labels = {
      name = local.jenkins_operator["namespace"]
    }

    name = local.jenkins_operator["namespace"]
  }
}

resource "helm_release" "jenkins" {
  count                 = local.jenkins_operator["enabled"] ? 1 : 0
  repository            = local.jenkins_operator["repository"]
  name                  = local.jenkins_operator["name"]
  chart                 = local.jenkins_operator["chart"]
  version               = local.jenkins_operator["chart_version"]
  timeout               = local.jenkins_operator["timeout"]
  force_update          = local.jenkins_operator["force_update"]
  recreate_pods         = local.jenkins_operator["recreate_pods"]
  wait                  = local.jenkins_operator["wait"]
  atomic                = local.jenkins_operator["atomic"]
  cleanup_on_fail       = local.jenkins_operator["cleanup_on_fail"]
  dependency_update     = local.jenkins_operator["dependency_update"]
  disable_crd_hooks     = local.jenkins_operator["disable_crd_hooks"]
  disable_webhooks      = local.jenkins_operator["disable_webhooks"]
  render_subchart_notes = local.jenkins_operator["render_subchart_notes"]
  replace               = local.jenkins_operator["replace"]
  reset_values          = local.jenkins_operator["reset_values"]
  reuse_values          = local.jenkins_operator["reuse_values"]
  skip_crds             = local.jenkins_operator["skip_crds"]
  verify                = local.jenkins_operator["verify"]
  values = [
    local.values_jenkins,
    local.jenkins_operator["extra_values"]
  ]
  namespace = local.jenkins_operator["namespace"]

  depends_on = [
    helm_release.kiam
  ]
}

resource "kubernetes_network_policy" "jenkins_default_deny" {
  count = local.jenkins_operator["create_ns"] && local.jenkins_operator["enabled"] && local.jenkins_operator["default_network_policy"] ? 1 : 0

  metadata {
    name      = "${kubernetes_namespace.jenkins_operator.*.metadata.0.name[count.index]}-default-deny"
    namespace = kubernetes_namespace.jenkins_operator.*.metadata.0.name[count.index]
  }

  spec {
    pod_selector {
    }
    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "jenkins_allow_namespace" {
  count = local.jenkins_operator["create_ns"] && local.jenkins_operator["enabled"] && local.jenkins_operator["default_network_policy"] ? 1 : 0

  metadata {
    name      = "${kubernetes_namespace.jenkins_operator.*.metadata.0.name[count.index]}-allow-namespace"
    namespace = kubernetes_namespace.jenkins_operator.*.metadata.0.name[count.index]
  }

  spec {
    pod_selector {
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = kubernetes_namespace.jenkins_operator.*.metadata.0.name[count.index]
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

