# Ban Specifications #

## Banning a Player (globally) ##
An example request to ban a player globally would be:

    http://gskw.noip.me:5678/bans/createBan/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    player=123456;reason="u r a stupid hax0r!!"
    
The ban would then be saved in the database, in the `bans` table.
An example response would be:

    success=true;error=""
    
## Checking if a player is banned ##
An example request to check if a player is banned would be:

    http://gskw.noip.me:5678/bans/isBanned/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    player=123456;
    
An example response would be:

    success=true;error="";result=[true,"u r a stupid hax0r!!","test"]
    
However, if the player was not banned, the response would look like:

    success=true;error="";result=[false]