create table if not exists users
(
    id         int auto_increment
        primary key,
    account_id varchar(36)                                                                                    not null,
    username   varchar(16)                                                                                    not null,
    password   varchar(64)                                                                                    not null,
    email      varchar(255)                                                                                   not null,
    role       enum ('banned', 'locked', 'pending', 'user', 'moderator', 'admin', 'developer') default 'user' not null,
    constraint account_id
        unique (account_id),
    constraint email
        unique (email),
    constraint id
        unique (id),
    constraint username
        unique (username)
);

create table if not exists user_details
(
    id              int auto_increment
        primary key,
    user_id         int                  not null,
    profile_picture varchar(2048)        null,
    full_name       varchar(64)          null,
    github_url      varchar(2048)        null,
    twitter_url     varchar(2048)        null,
    website_url     varchar(2048)        null,
    verified        tinyint(1) default 0 not null,
    constraint id
        unique (id),
    constraint user_details_users_id_fk
        foreign key (user_id) references users (id)
            on update cascade on delete cascade
);

create table if not exists user_history
(
    id         int auto_increment
        primary key,
    user_id    int                                                                                     not null,
    ip_address varchar(15)                                                                             not null,
    timestamp  timestamp default CURRENT_TIMESTAMP                                                     null,
    action     enum ('register', 'login', 'logout', 'verify_email', 'update_email', 'update_password') not null,
    constraint id
        unique (id),
    constraint user_history_users_id_fk
        foreign key (user_id) references users (id)
            on update cascade on delete cascade
);


