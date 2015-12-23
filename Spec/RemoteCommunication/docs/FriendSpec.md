# Friend Specifications #

## Listing friends ##
An example request to list all friends of an user would be:

    http://gskw.noip.me:5678/friends/getFriends/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    id=261
    
Then the player's friends would be fetched using `api.roblox.com/users/261/friends`.
An example reply would be:

    error="";result=[[46798282,"NicholasDev",true,"awesomeGame"],[999,"JustSomebody",false]];success=true
    
The first element in the array would be the friend's ID, the next would be a boolean specifying if the player is online. The third element would only be set if the player was online, and it would contain the ID of the game the player would be in.

## Changing a user's online game ##
An example request to change a user's online game would be:

    http://gskw.noip.me:5678/friends/setOnlineGame/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    id=261;game=awesomeGame
    
Then the player's current game would be set to awesomeGame.

## Making a user go offline ##
An example request to make a user go offline would be:

    http://gskw.noip.me:5678/friends/goOffline/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    id=261;time_ingame=999

`time_ingame` would be set to the number of seconds the player has been in the game.

The the player would be seen as offline (or not online at any game).