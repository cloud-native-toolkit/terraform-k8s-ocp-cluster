# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "The name of the IBM Cloud resource group where the cluster will be created/can be found."
  default     = ""
}

# Cluster Variables
variable "cluster_name" {
  type        = string
  description = "The name of the cluster that will be created within the resource group"
  default     = ""
}

# Cluster Variables
variable "cluster_machine_type" {
  type        = string
  description = "The machine type for the cluster worker nodes. The list of available machine types can be found using `ibmcloud ks machine-types <data-center>`"
  default     = ""
}

# Cluster Variables
variable "cluster_worker_count" {
  type        = string
  description = "The number of worker nodes for the cluster"
  default     = ""
}

# Cluster Variables
variable "cluster_hardware" {
  type        = string
  description = "The type of hardware for the cluster (shared, dedicated)"
  default     = ""
}

# Cluster Variables
variable "private_vlan_id" {
  type        = string
  description = "Existing private VLAN id for cluster creation."
  default     = ""
}

variable "public_vlan_id" {
  type        = string
  description = "Existing public VLAN number for cluster creation."
  default     = ""
}

variable "vlan_datacenter" {
  type        = string
  description = "Datacenter for VLANs defined in private_vlan_number and public_vlan_number."
  default     = ""
}

variable "cluster_region" {
  type        = string
  description = "The IBM Cloud region where the cluster will be/has been installed."
  default     = ""
}

variable "kubeconfig_download_dir" {
  type        = string
  description = "Directory where kubeconfig will be downloaded."
  default     = ""
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster that should be created (openshift or ocp3 or ocp4 or kubernetes)"
}

variable "login_user" {
  type        = string
  description = "The username to log in to openshift"
}

variable "login_password" {
  type        = string
  description = "The password to log in to openshift"
}

variable "server_url" {
  type        = string
  description = "The url to the server"
}
