locals {

  helm_defaults_defaults = {
    atomic                = false
    cleanup_on_fail       = false
    dependency_update     = false
    disable_crd_hooks     = false
    disable_webhooks      = false
    force_update          = false
    recreate_pods         = false
    render_subchart_notes = true
    replace               = false
    reset_values          = false
    reuse_values          = false
    skip_crds             = false
    timeout               = 3600
    verify                = false
    wait                  = true
    extra_values          = ""
  }

  helm_defaults = merge(
    local.helm_defaults_defaults,
    var.helm_defaults
  )

  // helm repositories

  helm_repository_stable = {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com/"
  }

  helm_repository_incubator = {
    name = "incubator"
    url  = "https://kubernetes-charts-incubator.storage.googleapis.com/"
  }
  // for fluentd-cloudwatch
  helm_repository_polarpoint = {
    name = "polarpoint"
    url  = "https://polarpoint-io.github.io/helm-charts/"
  }

  helm_repository_cert_manager = {
    name = "cert_manager"
    url  = "https://charts.jetstack.io/"
  }
  helm_repository_kiam = {
    name = "kiam"
    url  = "https://uswitch.github.io/kiam-helm-charts/charts/"
  }

  helm_repository_flux = {
    name = "flux"
    url  = "https://charts.fluxcd.io/"
  }

  helm_repository_keycloak = {
    name = "keycloak"
    url  = "https://codecentric.github.io/helm-charts/"
  }

  helm_repository_kong = {
    name = "kong"
    url  = "https://charts.konghq.com"
  }

  helm_repository_bitnami = {
    name = "bitnami"
    url  = "https://charts.bitnami.com/bitnami"
  }

  helm_repository_external_secrets = {
    name = "external_secrets"
    url  = "https://godaddy.github.io/kubernetes-external-secrets/"
  }

}