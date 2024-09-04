terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_container" "jenkins" {
  name  = "jenkins"
  image = "jenkins/jenkins:lts"
  ports {
    internal = 8080
    external = 8080
  }
}

resource "docker_container" "sonarqube" {
  name  = "sonarqube"
  image = "sonarqube:lts"
  ports {
    internal = 9000
    external = 9000
  }
}
