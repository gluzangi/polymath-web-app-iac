job "polymath-webapp" {
  datacenters   = ["dc1"]
  namespace     = "app-stg"
  type          = "service"

  group "webapp" {
    count = 1

    task "webapp" {
      driver = "docker"
      config {
        image     = "marcinpolymath/simplewebapp:latest"
        hostname  = "web-app"
        ports     = ["www-port"]
        volumes   = ["/mnt/disk/glusterfs.vol/gv0/DockerAppsData/service.terraform/polymath-iac:/tmp"]
      }

      env {
        DB_HOST=$NOMAD_HOST_IP_www-port
        DB_NAME="visitscounter"
        DB_USER="postgres"
        DB_PASS="postgres"
        DB_PORT="5432"
        DB_PARAMS="sslmode=disable"
      }

      resources {
        cpu = 1000
        memory = 1024
      }

      service {
        name = "www-server"
        port = "www-port"

        check {
          name     = "www-tcp"
          port     = "www-port"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }
    update {
      max_parallel = 1
      health_check = "task_states"
    }
    network {
      port  "www-port" {
        static = 8080
        to = 8080
      }
    }
  }
}
