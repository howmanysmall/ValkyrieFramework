# Database Specifications
Read AuthSpec.md first!

Note: This plan is not fully complete, but it contains everything required for
the authentication process.

## connections
This table will be used for saving TKeys that have not been activated yet.

### DESCRIBE

    +----------------+--------------+------+-----+---------+----------------+
    | Field          | Type         | Null | Key | Default | Extra          |
    +----------------+--------------+------+-----+---------+----------------+
    | id             | int(11)      | NO   | PRI | NULL    | auto_increment |
    | gid            | varchar(255) | YES  |     | NULL    |                |
    | connection_key | varchar(255) | YES  |     | NULL    |                |
    +----------------+--------------+------+-----+---------+----------------+

## game\_ids
This table will be used for saving activated TKeys and the associated GIDs

### DESCRIBE

    +-------+--------------+------+-----+---------+----------------+
    | Field | Type         | Null | Key | Default | Extra          |
    +-------+--------------+------+-----+---------+----------------+
    | id    | int(11)      | NO   | PRI | NULL    | auto_increment |
    | gid   | varchar(255) | NO   |     | NULL    |                |
    | tkey  | varchar(255) | NO   |     | NULL    |                |
    +-------+--------------+------+-----+---------+----------------+

## trusted\_users\_*
These tables will be used for saving each game's trusted place owners.

### DESCRIBE

    +----------------+--------------+------+-----+---------+----------------+
    | Field          | Type         | Null | Key | Default | Extra          |
    +----------------+--------------+------+-----+---------+----------------+
    | id             | int(11)      | NO   | PRI | NULL    | auto_increment |
    | uid            | int(11)      | NO   |     | NULL    |                |
    | connection_key | varchar(255) | NO   |     | NULL    |                |
    +----------------+--------------+------+-----+---------+----------------+

## messages
This table will be used for saving global chat messages.

### DESCRIBE

    +---------+--------------+------+-----+---------+----------------+
    | Field   | Type         | Null | Key | Default | Extra          |
    +---------+--------------+------+-----+---------+----------------+
    | id      | int(11)      | NO   | PRI | NULL    | auto_increment |
    | sent    | int(11)      | NO   |     | NULL    |                |
    | user    | varchar(255) | NO   |     | NULL    |                |
    | message | text         | NO   |     | NULL    |                |
    | gid     | varchar(255) | NO   |     | NULL    |                |
    +---------+--------------+------+-----+---------+----------------+

## achievements\_*
These tables will be used for saving the achievements for each game.

### DESCRIBE

    +-------------+--------------+------+-----+---------+----------------+
    | Field       | Type         | Null | Key | Default | Extra          |
    +-------------+--------------+------+-----+---------+----------------+
    | id          | int(11)      | NO   | PRI | NULL    | auto_increment |
    | achv_id     | varchar(255) | NO   |     | NULL    |                |
    | name        | varchar(255) | NO   |     | NULL    |                |
    | description | text         | NO   |     | NULL    |                |
    | reward      | int(11)      | NO   |     | NULL    |                |
    | icon        | int(11)      | NO   |     | NULL    |                |
    +-------------+--------------+------+-----+---------+----------------+


## player\_achv\_*
These tables will be used for saving the achievements awarded to each player.

### DESCRIBE

    +--------+--------------+------+-----+---------+----------------+
    | Field  | Type         | Null | Key | Default | Extra          |
    +--------+--------------+------+-----+---------+----------------+
    | id     | int(11)      | NO   | PRI | NULL    | auto_increment |
    | achvid | varchar(255) | NO   |     | NULL    |                |
    | gid    | varchar(255) | NO   |     | NULL    |                |
    +--------+--------------+------+-----+---------+----------------+

## meta\_*
These tables will be used for saving metadata for each game.

### DESCRIBE

    +-------+--------------+------+-----+---------+----------------+
    | Field | Type         | Null | Key | Default | Extra          |
    +-------+--------------+------+-----+---------+----------------+
    | id    | int(11)      | NO   | PRI | NULL    | auto_increment |
    | key   | varchar(255) | NO   |     | NULL    |                |
    | value | varchar(255) | NO   |     | NULL    |                |
    +-------+--------------+------+-----+---------+----------------+

## player_ingame
This table will be used for saving the players who are in a game.

### DESCRIBE

    +--------+--------------+------+-----+---------+-------+
    | Field  | Type         | Null | Key | Default | Extra |
    +--------+--------------+------+-----+---------+-------+
    | id     | int(11)      | NO   | PRI | NULL    |       |
    | player | int(11)      | NO   |     | NULL    |       |
    | gid    | varchar(255) | NO   |     | NULL    |       |
    +--------+--------------+------+-----+---------+-------+

## bans
This table will be used for saving the banned players.

### DESCRIBE

    +----------+--------------+------+-----+---------+----------------+
    | Field    | Type         | Null | Key | Default | Extra          |
    +----------+--------------+------+-----+---------+----------------+
    | id       | int(11)      | NO   | PRI | NULL    | auto_increment |
    | player   | int(11)      | NO   |     | NULL    |                |
    | reason   | varchar(255) | NO   |     | NULL    |                |
    | from_gid | varchar(255) | NO   |     | NULL    |                |
    +----------+--------------+------+-----+---------+----------------+

## player\_info
This table will be used for saving the stats of players.

### DESCRIBE

    +-------------+---------+------+-----+---------+----------------+
    | Field       | Type    | Null | Key | Default | Extra          |
    +-------------+---------+------+-----+---------+----------------+
    | id          | int(11) | NO   | PRI | NULL    | auto_increment |
    | player      | int(11) | NO   |     | NULL    |                |
    | time_ingame | int(11) | NO   |     | NULL    |                |
    | joined      | int(11) | NO   |     | NULL    |                |
    | last_online | int(11) | NO   |     | NULL    |                |
    +-------------+---------+------+-----+---------+----------------+
