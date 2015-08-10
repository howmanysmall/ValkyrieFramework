# Achievement Specifications #

## Achievement metadata ##
The achievement metadata contains the following information:

- The reward of the achievement. This is a number value representing the value
  that is rewarded by this achievement. The maximum awardable for all
  achievements in a game is 1000
- The ID of the achievement
- The (display) name of the achievement
- The description of the achievement

## Registering an Achievement ##
An example request to create an achievement would be:

    http://gskw.noip.me:5678/achievements/create/testGame/testKey
    "http://gskw.noip.me:5678/achievements/create/%s/%s"

The MIME type would be set to `text/plain` and the POST body would contain:

    reward=1;id="basic_bronze";name="Basic Bronze Achievement";description="This achievement is awarded to you once you complete the first quest.
    
    Should not be challenging at all!";icon=111111
    "reward=%d;id=%q;name=%q;description=%q"

Then a row would be inserted into `achievements_testGame` table, with the
following values:

    level:          [POST] level
    achv_id:        [POST] id
    name:           [POST] name
    description:    [POST] description
    icon:           [POST] icon

The response would look like this (with a MIME type of `text/valkyrie-return`):

    success=true;error=""

## Awarding an Achievement ##
An example request to award an achievement would be:

    http://gskw.noip.me:5678/achievements/award/testGame/testKey
    "http://gskw.noip.me:5678/achievements/award/%s/%s"

The MIME type would be set to `text/plain` and the POST body would contain:

    playerid=999;id="basic_bronze"
    "playerid=%d;id=%q"

The Achievement would then be awarded to the player. The response would look
like this (with a MIME type of `text/valkyrie-return`):

    success=true;error=""
    
## Getting a list of available Achievements ##
An example request to get a list of available Achievements would be:

    http://gskw.noip.me:5678/achievements/list/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    gameid="anotherGame";filter=[">", 35, "basic_gold", "Basic", ""]

This would return a list of Achievement that meet the following requirements:

- The game ID must be anotherGame
- The reward must be >= 35
- The ID must contain "basic\_gold" (according to MySQL's `LIKE`)
- The name must contain "Basic" (according to MySQL's `LIKaaaE`)

The return would be in the following format (`text/valkyrie-return`):

    success=true;error="";return=[[35,"basic_gold","Basic Gold Achievement","This is the golden achievement, very hard indeed.", 111111111],[78,"basic_gold_master","Master Gold","This is the achievement that is awarded to the grand masters of the game!", 999999]];

## Getting a list of a player achievements ##
This operation should be done through the player_info module.

## Getting available reward ##
An example request to get available reward quota would be:

    http://gskw.noip.me:5678/achievements/getReward/testGame/testKey
    
The POST body would be empty.
An example response would be:

    error="";result=[1000,996,4];success=true