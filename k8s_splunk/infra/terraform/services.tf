resource kubernetes_namespace app_namespace {
  metadata {
    name = "app"
  }
}

resource kubernetes_deployment server_deployment {
  metadata {
    name      = "server-deployment"
    namespace = kubernetes_namespace.app_namespace.metadata.0.name
    labels = {
      app = "server"
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "server"
      }
    }
    template {
      metadata {
        labels = {
          app = "server"
        }
      }
      spec {
        container {
          name  = "server"
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/server"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource kubernetes_service server_service {
  metadata {
    name      = "server-service"
    namespace = kubernetes_namespace.app_namespace.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.server_deployment.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource kubernetes_deployment client_deployment {
  metadata {
    name      = "client-deployment"
    namespace = kubernetes_namespace.app_namespace.metadata.0.name
    labels = {
      app = "client"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "client"
      }
    }
    template {
      metadata {
        labels = {
          app = "client"
        }
      }
      spec {
        container {
          name  = "client"
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/client"
          env {
            name  = "SERVER"
            value = kubernetes_service.server_service.spec.0.cluster_ip
          }
        }
      }
    }
  }
}
