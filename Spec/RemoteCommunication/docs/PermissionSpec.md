# Permission Specifications #

## Available permissions ##
- modules.require
- modules.function
- modules.*
- achievements.award
- achievements.create
- achievements.list
- achievementes.*
- auth.check
- auth.*
- loadstring.load
- loadstring.lockAsset
- loadstring.*
- messages.addMessage
- nessages.checkMessages
- messages.*
- playerinfo.getUserinfo
- playerinfo.*
- friends.getFriends
- friends.setOnlineGame
- friends.goOffline
- friends.*
- \*.\*

## Format ##
The permissions are saved in the `permissions.perms` file in the following format:
It only supports 2 levels of permissions. That means, permission keys such as
`friends.bestFriends.getBestFriends` are not allowed

    :[gid]
    [+/-][permissionName]