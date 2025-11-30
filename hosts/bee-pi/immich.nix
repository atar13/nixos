{ pkgs, lib, config, ... }:
let
  immich = {
    image = "ghcr.io/imagegenius/immich";
    # see here https://github.com/imagegenius/docker-immich/pkgs/container/immich
    tag = "arm64v8-1.106.4-noml";
    digest = "sha256:6a525793a9082a02ada8c046d1b651a8c8004f76b13eba4c26181f6b583811ed";
  };
  wrapImage = { name, imageName, tag, imageDigest, sha256, entrypoint }:
    pkgs.dockerTools.buildImage ({
      name = name;
      tag = tag;
      fromImage = pkgs.dockerTools.pullImage {
        imageName = imageName;
        imageDigest = imageDigest;
        sha256 = sha256;
      };
      created = "now";
      config =
        if builtins.length entrypoint == 0
        then null
        else {
          Cmd = entrypoint;
          WorkingDir = "/usr/src/app";
        };
    });
in
{
  age.secrets.immich-db-password.file = ../../secrets/immich-db-password.age;
  age.secrets.immich-redis-password.file = ../../secrets/immich-redis-password.age;
  age.secrets.immich-typesense-api-key.file = ../../secrets/immich-typesense-api-key.age;

  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."immich" = {
    imageFile = wrapImage {
      name = "immich";
      imageName = "${immich.image}";
      tag = immich.tag;
      imageDigest = "${immich.digest}";
      sha256 = "Tp4fxPIHEIXOWImcLFLxVP7stFgNXpTqomDadddXIOg=";
      entrypoint = [ ];
    };
    image = "${immich.image}:${immich.tag}";
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
      "3001:3001/tcp"
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
    image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
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
