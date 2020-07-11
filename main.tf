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
  registry_url          = "image-registry.openshift-image-registry.svc:5000"
  ibmcloud_release_name = "ibmcloud-config"
  cluster_type_cleaned  = regex("(kubernetes|iks|openshift|ocp3|ocp4).*", var.cluster_type)[0]
  cluster_type          = local.cluster_type_cleaned == "ocp3" ? "openshift" : (local.cluster_type_cleaned == "ocp4" ? "openshift" : (local.cluster_type_cleaned == "iks" ? "kubernetes" : local.cluster_type_cleaned))
  # value should be ocp4, ocp3, or kubernetes
  cluster_type_code     = local.cluster_type_cleaned == "openshift" ? "ocp3" : (local.cluster_type_cleaned == "iks" ? "kubernetes" : local.cluster_type_cleaned)
  cluster_type_tag      = local.cluster_type == "kubernetes" ? "iks" : "ocp"
}

resource "null_resource" "oc_login" {
  count = local.cluster_type == "openshift" ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "oc login --insecure-skip-tls-verify=true -u ${var.login_user} -p ${var.login_password} --server=${var.server_url} > /dev/null"
  }
}

resource "null_resource" "delete_ibmcloud_chart" {
  depends_on = [null_resource.oc_login]

  provisioner "local-exec" {
    command = "${path.module}/scripts/helm3-uninstall.sh ${local.ibmcloud_release_name} ${local.config_namespace}"

    environment = {
      KUBECONFIG = local.config_file_path
    }
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
    value = var.cluster_type
  }

  set {
    name  = "region"
    value = var.cluster_region
  }

  set {
    name  = "registry_url"
    value = local.registry_url
  }

  set {
    name  = "registry_namespace"
    value = var.registry_namespace
  }
}
