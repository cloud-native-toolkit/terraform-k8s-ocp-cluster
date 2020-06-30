provider "helm" {
  version = ">= 1.1.1"

  kubernetes {
    config_path = local.config_file_path
  }
}

provider "null" {
}

locals {
  cluster_config_dir    = pathexpand("~/.kube")
  config_file_path      = "${local.cluster_config_dir}/config"
  config_namespace      = "default"
  ibmcloud_apikey_chart = "${path.module}/charts/ibmcloud"
  cluster_name          = "crc"
  tls_secret_file       = ""
  tmp_dir               = "${path.cwd}/.tmp"
  registry_url          = "image-registry.openshift-image-registry:5000"
  ibmcloud_release_name = "ibmcloud-config"
  cluster_type          = var.cluster_type == "ocp3" ? "openshift" : (var.cluster_type == "ocp4" ? "openshift" : var.cluster_type)
  # value should be ocp4, ocp3, or kubernetes
  cluster_type_code     = var.cluster_type == "openshift" ? "ocp3" : var.cluster_type
  cluster_type_tag      = var.cluster_type == "kubernetes" ? "iks" : "ocp"
}

resource "null_resource" "oc_login" {
  provisioner "local-exec" {
    command = "oc login --insecure-skip-tls-verify=true -u ${var.login_user} -p ${var.login_password} --server=${var.server_url} > /dev/null"
  }
}

resource "helm_release" "ibmcloud_config" {
  depends_on = [null_resource.oc_login]

  name         = local.ibmcloud_release_name
  chart        = "ibmcloud"
  repository   = "https://ibm-garage-cloud.github.io/toolkit-charts"
  version      = "0.1.3"
  namespace    = local.config_namespace

  set {
    name  = "resource_group"
    value = var.resource_group_name
  }

  set {
    name  = "server_url"
    value = var.server_url
  }

  set {
    name  = "cluster_type"
    value = local.cluster_type
  }

  set {
    name  = "cluster_name"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = var.cluster_region
  }

  set {
    name  = "registry_url"
    value = local.registry_url
  }
}
