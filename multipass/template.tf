data "template_file" "cloud_init_master" {
    template = "${file("${path.module}/script/cloud-init.yaml")}"
    vars = {
        ssh_public_key = "${file(pathexpand("~/.ssh/id_rsa.pub"))}"
        extra_cmd = ""
    }
}

data "template_file" "cloud_init_worker" {
    template = "${file("${path.module}/script/cloud-init.yaml")}"
    vars = {
        ssh_public_key = "${file(pathexpand("~/.ssh/id_rsa.pub"))}"
        extra_cmd = "- ${data.external.kubejoin.result.join}"
    }
}



