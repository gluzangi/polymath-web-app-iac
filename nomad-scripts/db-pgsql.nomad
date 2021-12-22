job "polymath-db" {
  datacenters   = ["dc1"]
  namespace     = "db-engines"
  type          = "service"

  group "postgresql" {
    count = 1

    task "postgresql" {
      driver = "docker"
      config {
        image     = "postgres:14.1"
        hostname  = "db-pgsql"
        ports     = ["db-port"]
        volumes   = ["/mnt/disk/glusterfs.vol/gv0/DockerAppsData/service.terraform/nomad/db-pgsql:/docker-entrypoint-initdb.d"]
      }

      env {
        POSTGRES_HOST=$NOMAD_HOST_IP_www-ports
        POSTGRES_DB="visitscounter"
        POSTGRES_USER="postgres"
        POSTGRES_PASSWORD="postgres"
        POSTGRES_INITDB_ARGS="--data-checksums"
        PGDATA="/var/lib/postgresql/data/pgdata"
      }

      logs {
        max_files     = 5
        max_file_size = 15
      }

      resources {
        cpu = 1000
        memory = 1024
      }

      service {
        name = "pgsql-server"
        port = "db-port"

        check {
          name     = "postgresql-tcp"
          port     = "db-port"
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
      port  "db-port" {
        static = 5432
        to = 5432
      }
    }
  }
}
