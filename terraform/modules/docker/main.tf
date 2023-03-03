# build and push...yes I know this should be a pipeline activity/cloudbuild
data "external" "hash" {
  program = [coalesce(var.hash_script, "${path.module}/hash.sh"), var.source_path]
}

# Build and push the Docker image whenever the hash changes
resource "null_resource" "push" {
  triggers = {
    hash = data.external.hash.result["hash"]
  }

  provisioner "local-exec" {
    command     = <<COMMAND
cd ${var.source_path} && docker build -t ${var.image_name}:${var.tag} . \
&&  echo "${var.ecr_authorization_token}" | cut -d' ' -f2 | docker login --username AWS --password-stdin "${var.ecr_repository_url}" \
&& docker tag "${var.image_name}:${var.tag}" "${var.ecr_repository_url}:${var.tag}" \
&& docker push "${var.ecr_repository_url}:${var.tag}"
COMMAND
    interpreter = ["bash", "-c"]
  }
}