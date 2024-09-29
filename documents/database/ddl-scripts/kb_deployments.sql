create table if not exists deployments
(
    id          int auto_increment
        primary key,
    instance_id varchar(36)                                                                             not null,
    event_id    varchar(36)                                                                             not null,
    status      enum ('preparing', 'idle', 'ready', 'live', 'teardown', 'complete') default 'preparing' not null,
    constraint id
        unique (id)
);

create table if not exists ecs_clusters
(
    id            int auto_increment
        primary key,
    aws_arn       varchar(512)                                                            not null,
    cluster_name  varchar(36)                                                             not null,
    deployment_id int                                                                     not null,
    status        enum ('active', 'provisioning', 'deprovisioning', 'failed', 'inactive') not null,
    constraint cluster_name
        unique (cluster_name),
    constraint id
        unique (id),
    constraint ecs_clusters_deployments_id_fk
        foreign key (deployment_id) references deployments (id)
            on update cascade on delete cascade
);

create table if not exists ecs_task_definitions
(
    id        int auto_increment
        primary key,
    family_id varchar(36)  not null,
    aws_arn   varchar(512) not null,
    constraint id
        unique (id)
);

create table if not exists ecs_task_instances
(
    id                     int auto_increment
        primary key,
    aws_arn                varchar(512)                                               not null,
    ecs_task_definition_id int                                                        not null,
    ecs_cluster_id         int                                                        not null,
    pull_start             timestamp                                                  null,
    pull_stop              timestamp                                                  null,
    started_at             timestamp                                                  null,
    stopped_at             timestamp                                                  null,
    stopped_reason         varchar(512)                                               null,
    status                 enum ('healthy', 'unhealthy', 'unknown') default 'unknown' not null,
    instance_owner_id      varchar(36)                                                not null,
    constraint id
        unique (id),
    constraint ecs_task_instances_ecs_clusters_id_fk
        foreign key (ecs_cluster_id) references ecs_clusters (id)
            on update cascade on delete cascade,
    constraint ecs_task_instances_ecs_task_definitions_id_fk
        foreign key (ecs_task_definition_id) references ecs_task_definitions (id)
            on update cascade on delete cascade
);

create table if not exists efs_instances
(
    id              int auto_increment
        primary key,
    deployment_id   int                                                                                     not null,
    aws_resource_id varchar(64)                                                                             not null,
    state           enum ('destroyed', 'creating', 'available', 'updating', 'deleting', 'deleted', 'error') not null,
    constraint id
        unique (id)
);

create table if not exists vpc_instances
(
    id              int auto_increment
        primary key,
    deployment_id   int                                        null,
    aws_resource_id varchar(64)                                null,
    state           enum ('destroyed', 'pending', 'available') not null,
    constraint id
        unique (id),
    constraint vpc_instances_deployments_id_fk
        foreign key (deployment_id) references deployments (id)
            on update cascade on delete cascade
);

create table if not exists vpc_security_rules
(
    id              int auto_increment
        primary key,
    vpc_instance_id int                                         not null,
    ip_address      varchar(15)                                 not null,
    ingress         tinyint(1) default 0                        not null,
    egress          tinyint(1) default 0                        null,
    state           enum ('authorized', 'revoked', 'destroyed') not null,
    constraint id
        unique (id),
    constraint vpc_security_rules_vpc_instances_id_fk
        foreign key (vpc_instance_id) references vpc_instances (id)
            on update cascade on delete cascade
);


