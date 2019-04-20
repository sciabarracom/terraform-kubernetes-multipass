output "master" {
    value = "${data.external.master.result.name}"
}

output "workers" {
    value = "${join(",", data.external.workers.*.result.name)}"
}