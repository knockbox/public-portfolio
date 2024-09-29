create table if not exists teams
(
    id       int auto_increment
        primary key,
    group_id varchar(36) not null,
    owner_id varchar(36) null,
    name     varchar(32) not null,
    constraint id
        unique (id),
    constraint name
        unique (name),
    constraint team_id
        unique (group_id)
);

create table if not exists team_details
(
    id              int auto_increment
        primary key,
    team_id         int           not null,
    profile_picture varchar(2048) null,
    description     mediumtext    null,
    github_url      varchar(2048) null,
    twitter_url     varchar(2048) null,
    website_url     varchar(2048) null,
    constraint id
        unique (id),
    constraint team_details_teams_id_fk
        foreign key (team_id) references teams (id)
            on update cascade on delete cascade
);

create table if not exists team_history
(
    id         int auto_increment
        primary key,
    group_id   int                                                                                                                                                                                             not null,
    account_id varchar(36)                                                                                                                                                                                     not null,
    timestamp  timestamp default CURRENT_TIMESTAMP                                                                                                                                                             not null,
    action     enum ('create_team', 'archive_team', 'unarchive_team', 'member_join', 'member_leave', 'member_invite', 'member_decline', 'member_request_invite', 'member_remove', 'update_member_permissions') not null,
    constraint id
        unique (id),
    constraint team_history_teams_id_fk
        foreign key (group_id) references teams (id)
            on update cascade on delete cascade
);

create table if not exists team_members
(
    id         int auto_increment
        primary key,
    team_id    int                                                            not null,
    member_id  varchar(36)                                                    not null,
    status     enum ('invited', 'declined', 'member', 'requested', 'removed') not null,
    can_invite tinyint(1) default 0                                           not null,
    can_manage tinyint(1) default 0                                           not null,
    constraint id
        unique (id),
    constraint team_members_teams_id_fk
        foreign key (team_id) references teams (id)
            on update cascade on delete cascade
);


