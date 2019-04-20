resource "null_resource" "workers" {

    triggers = {
        id = "${data.external.workers[count.index].result.ip}"
    }

    connection {
        type = "ssh"
        host = "${data.external.workers[count.index].result.ip}"
        user = "root"
        private_key = "${file(pathexpand("~/.ssh/id_rsa"))}"
   }   

    provisioner "remote-exec" {
        inline = [
            "cloud-init status --wait"
        ]
    }
    
    count = "${length(var.workers)}"
}

