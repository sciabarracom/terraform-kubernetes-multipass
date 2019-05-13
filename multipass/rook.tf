resource "null_resource" "rook" {
  
    depends_on = ["null_resource.workers"]

    triggers = {
        id = "${data.external.master.result.ip}"
    }

    connection {
        type = "ssh"
        host = "${data.external.master.result.ip}"
        user = "root"
        private_key = "${file(pathexpand("~/.ssh/id_rsa"))}"
    }
 
    provisioner "remote-exec" {
        script = "${path.module}/script/rook-init.sh"
    }
}

