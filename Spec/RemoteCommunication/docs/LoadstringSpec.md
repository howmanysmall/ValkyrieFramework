# Loadstring specifications #

## Creating a function ##
An example request to create a function would be:

    http://gskw.noip.me:5678/loadstring/load/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    source="return function(...)
        return {...};
    end"

Then a model would be uploaded to Roblox with the ValkyrieBot account.
Its hiearchy would be the following:

    Model
    \
     MainModule
     
The client would the require the module by ID.

## Copylocking an asset ##
An example request to copylock an asset would be:

    http://gskw.noip.me:5678/loadstring/lockAsset/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    id=1818
    
Then the model with the ID 1818 would be TRIED to make copylocked.
