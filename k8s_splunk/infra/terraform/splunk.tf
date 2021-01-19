resource helm_release signalfx_agent {
  name             = "signalfx-agent"
  namespace        = "splunk"
  create_namespace = true
  repository       = "https://dl.signalfx.com/helm-repo"
  chart            = "signalfx-agent"
  set {
    name  = "clusterName"
    value = coalesce(var.signalfx_cluster_name, var.eks_cluster_name)
  }
  set {
    name  = "signalFxAccessToken"
    value = var.signalfx_access_token
  }
  set {
    name  = "signalFxRealm"
    value = var.signalfx_realm
  }
  values = [file("splunk-values.yaml")]
}
