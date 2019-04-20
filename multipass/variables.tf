variable "disk" {
    default = "10G"
}

variable "mem" {
    default = "4G"
}

variable "cpu" {
    default = 2
}

variable "master" {
    default = "kube0"
}

variable "workers" {
  description = "workers"
  default = [ "kube1", "kube2", "kube3" ]
}


