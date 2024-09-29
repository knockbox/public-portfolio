create table if not exists events
(
    id           int auto_increment
        primary key,
    activity_id  varchar(36)          not null,
    organizer_id varchar(36)          not null,
    name         varchar(64)          not null,
    starts_at    datetime             not null,
    ends_at      datetime             not null,
    image_name   varchar(256)         not null,
    image_tag    varchar(256)         null,
    private      tinyint(1) default 0 not null,
    constraint event_id
        unique (activity_id),
    constraint id
        unique (id),
    constraint name
        unique (name)
);

create table if not exists event_details
(
    id              int auto_increment
        primary key,
    event_id        int           not null,
    profile_picture varchar(2048) null,
    description     mediumtext    null,
    github_url      varchar(2048) null,
    twitter_url     varchar(2048) null,
    website_url     varchar(2048) null,
    constraint id
        unique (id),
    constraint event_details_events_id_fk
        foreign key (event_id) references events (id)
            on update cascade on delete cascade
);

create table if not exists event_flags
(
    id         int auto_increment
        primary key,
    event_id   int                                                       not null,
    flag_id    varchar(36)                                               not null,
    difficulty enum ('very_easy', 'easy', 'medium', 'hard', 'very_hard') not null,
    env_var    varchar(128)                                              not null,
    constraint id
        unique (id),
    constraint flags_events_id_fk
        foreign key (event_id) references events (id)
            on update cascade on delete cascade
);

create table if not exists event_flag_history
(
    id          int auto_increment
        primary key,
    event_id    int                                 not null,
    flag_id     int                                 not null,
    timestamp   timestamp default CURRENT_TIMESTAMP not null,
    redeemer_id varchar(36)                         not null,
    constraint id
        unique (id),
    constraint event_flag_history_event_flags_id_fk
        foreign key (flag_id) references event_flags (id)
            on update cascade on delete cascade,
    constraint event_flag_history_events_id_fk
        foreign key (event_id) references events (id)
            on update cascade on delete cascade
);

create table if not exists event_participants
(
    id             int auto_increment
        primary key,
    event_id       int                                                                      not null,
    participant_id varchar(36)                                                              not null,
    team_id        varchar(36)                                                              null,
    status         enum ('invited', 'declined', 'member', 'requested', 'removed', 'banned') not null,
    can_invite     tinyint(1) default 0                                                     not null,
    can_manage     tinyint(1) default 0                                                     not null,
    constraint id
        unique (id),
    constraint event_participants_events_id_fk
        foreign key (event_id) references events (id)
            on update cascade on delete cascade
);


