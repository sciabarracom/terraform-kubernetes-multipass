data "external" "master" {
   program = ["python3", "${path.module}/script/multipass.py" ]
   query = {
     name = "${var.master}"
     cpu  = "${var.cpu}"
     mem  = "${var.mem}"
     disk = "${var.disk}"
     init = "${data.template_file.cloud_init_master.rendered}"
   }
}

data "external" "workers" {
  program = ["python3", "${path.module}/script/multipass.py"]
  query = {
    name = "${element(var.workers, count.index)}"
     cpu  = "${var.cpu}"
     mem  = "${var.mem}"
     disk = "${var.disk}"
     init = "${data.template_file.cloud_init_worker.rendered}"
  }
  count = "${length(var.workers)}"
}

data "external" "kubejoin" {
  depends_on = ["null_resource.master"]
  program = ["ssh", 
     "-i", "${pathexpand("~/.ssh/id_rsa")}", 
     "-l", "root",
     "${data.external.master.result.ip}",
     "cat", "/etc/join.json"
    ]
}
