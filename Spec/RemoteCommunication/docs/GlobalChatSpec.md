# Global Chat specifications #

## Creating a message ##
An example request to create a message would be:

    http://gskw.noip.me:5678/messages/addMessage/testGame/testKey
    
The MIME type would be set to ~~`text/valkyrie-request`~~ `text/plain` (because 
ROBLOX doesn't support the former) and the POST body would contain:

    user=261;message="Good morning, world, and all who inhabit it!"
    
Then a row would be inserted to the `messages` table, with the following values:

    sent:     [Lua]   require"socket".gettime()
    user:     [POST]  user
    message:  [POST]  message
    gid:      [URL]   gid
    
The response would look like this (with a MIME type of `text/valkyrie-return`):

    success=true;error=""
    
## Checking for new messages ##
An example request to check for new messages would be:

    http://gskw.noip.me:5678/messages/checkMessages/testGame/testKey
    
The MIME type would be set to ~~`text/valkyrie-request`~~ `text/plain` (because 
ROBLOX doesn't support the former) and the POST body would contain (where since 
is an UNIX timestamp):

    since=1421492844;gid="testGame"
    
A list of new messages would then be fetched from the `messages` table. The 
response would look like this (with a MIME type of `text/valkyrie-return`):

    success=true;error="";result=[1421567993,[261,"Hello guys",1421493444,"testGame"], 
    117224,"Hello John!",1421497921,"testGame"],[987654,"Oh, hello Matt!",1421499901,"testGame"]]
    
The first element returned is the current UNIX timestamp and it is followed by
the messages, which are stored as "user ID, message content, timestamp"

Additionally an extra parameter, `fresh` can be added to the POST body to tell
the server that the user freshly joined.

    since=0;fresh=true

This will return the current UNIX timestamp, like so:

    success=true;error="";result=1421567993