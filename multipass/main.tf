resource "null_resource" "master" {

    triggers = {
        id = "${data.external.master.result.ip}"
    }

    connection {
        type = "ssh"
        host = "${data.external.master.result.ip}"
        user = "root"
        private_key = "${file(pathexpand("~/.ssh/id_rsa"))}"
    }
 
    provisioner "file" {
        source = "${path.module}/script/kube-init.sh"
        destination = "/tmp/kube-init.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "cloud-init status --wait",
            "chmod +x /tmp/kube-init.sh",
            "bash /tmp/kube-init.sh",
        ]
    }

    provisioner "local-exec" {
        command = <<CMD
mkdir ${pathexpand("~/.kube")}
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -i ${pathexpand("~/.ssh/id_rsa")} root@${data.external.master.result.ip}:/etc/kubernetes/admin.conf ${pathexpand("~/.kube/config")}
CMD 
    }
}

