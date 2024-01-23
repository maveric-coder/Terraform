provider "docker" {}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "nginx"
  ports {
    internal = 80
    external = var.external_port
    protocol = "tcp"
  }
}

output "url" {
  description = "Browser URL for container site"
  value       = join(":", ["http://localhost", tostring(var.external_port)])
}
