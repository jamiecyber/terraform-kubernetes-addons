data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com/"
}

data "helm_repository" "incubator" {
  name = "incubator"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com/"
}
// for fluentd-cloudwatch
data "helm_repository" "polarpoint" {
  name = "polarpoint"
  url  = "https://polarpoint-io.github.io/helm-charts/"
}

data "helm_repository" "cert_manager" {
  name = "cert_manager"
  url  = "https://charts.jetstack.io/"
}
data "helm_repository" "kiam" {
  name = "kiam"
  url  = "https://uswitch.github.io/kiam-helm-charts/charts/"
}

data "helm_repository" "flux" {
  name = "flux"
  url  = "https://charts.fluxcd.io/"
}

data "helm_repository" "keycloak" {
  name = "keycloak"
  url  = "https://codecentric.github.io/helm-charts/"
}

data "helm_repository" "kong" {
  name = "kong"
  url  = "https://charts.konghq.com"
}
