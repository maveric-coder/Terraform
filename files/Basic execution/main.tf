terraform {
  required_providers {  
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

provider "docker" {
  
}

resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx_container" {
  image = docker.image.nginx.latest
  name = "nginx"
  ports {
    internal = 80
    external = 8080
  }
  
}