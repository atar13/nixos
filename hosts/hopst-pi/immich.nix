# Auto-generated using compose2nix v0.1.6.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."immich" = {
    image = "ghcr.io/imagegenius/immich:arm64v8-noml";
    environment = {
      DB_DATABASE_NAME = "immich";
      DB_HOSTNAME = "postgres14";
      DB_PASSWORD = "postgres";
      DB_PORT = "5432";
      DB_USERNAME = "postgres";
      DISABLE_MACHINE_LEARNING = "true";
      DISABLE_TYPESENSE = "true";
      MACHINE_LEARNING_WORKERS = "0";
      MACHINE_LEARNING_WORKER_TIMEOUT = "0";
      PGID = "1000";
      PUID = "1000";
      REDIS_HOSTNAME = "redis";
      REDIS_PASSWORD = "";
      REDIS_PORT = "6379";
      TYPESENSE_API_KEY = "123";
      TZ = "Etc/UTC";
    };
    volumes = [
      "/data/Photos/immich/config:/config:rw"
      "/data/Photos/immich/import:/import:ro"
      "/data/Photos/immich/photos:/photos:rw"
    ];
    ports = [
      "8080:8080/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=immich"
      "--network=photos-default"
    ];
  };
  systemd.services."docker-immich" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "docker-network-photos-default.service"
    ];
    requires = [
      "docker-network-photos-default.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };
  virtualisation.oci-containers.containers."postgres14" = {
    image = "tensorchord/pgvecto-rs:pg14-v0.1.11";
    environment = {
      POSTGRES_DB = "immich";
      POSTGRES_PASSWORD = "postgres";
      POSTGRES_USER = "postgres";
    };
    volumes = [
      "/data/postgresql/data:/var/lib/postgresql/data:rw"
    ];
    ports = [
      "5432:5432/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=postgres14"
      "--network=photos-default"
    ];
  };
  systemd.services."docker-postgres14" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [
      "docker-network-photos-default.service"
    ];
    requires = [
      "docker-network-photos-default.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };
  virtualisation.oci-containers.containers."redis" = {
    image = "redis";
    ports = [
      "6379:6379/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=redis"
      "--network=photos-default"
    ];
  };
  systemd.services."docker-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [
      "docker-network-photos-default.service"
    ];
    requires = [
      "docker-network-photos-default.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-photos-default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.docker}/bin/docker network rm -f photos-default";
    };
    script = ''
      docker network inspect photos-default || docker network create photos-default
    '';
    partOf = [ "docker-compose-photos-root.target" ];
    wantedBy = [ "docker-compose-photos-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-photos-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
