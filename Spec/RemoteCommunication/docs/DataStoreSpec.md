# Data Store Specifications #
 
## Saving data in the data store ##
An example request to save data in the data store would be:

    http://gskw.noip.me:5678/datastore/saveData/testGame/testKey
    
The MIME type would be set to `text/plain` and the POST body would contain:

    key="highScore";value="261_234"
    
There is a limit of 10 MiB.

## Loading data from the data store ##
An example request to load data from the data store would be:

    http://gskw.noip.me:5678/datastore/loadData/testGame/testKey

The MIME type would be set to `text/plain` and the POST body would contain:

    key="highScore"
    
An example response would be:

    success=true;error="";result="261_234"
    
## Listing all saved keys in the data store ##
An example request to get a list of saved keys in the data store would be:

    http://gskw.noip.me:5678/datastore/listKeys/testGame/testKey
    
The POST body would be empty.
An example response would be:

    success=true;error="";result=["highScore","playerInfo/Sorcus","playerInfo/Shedletsky"]
    
## Getting information about the available space ##
An example request to get information about the available space would be:

    http://gskw.noip.me:5678/datastore/getSpace/testGame/testKey
    
The POST body would be empty.
An example response would be:

    success=true;error="";result=[["10 MiB","~10.000 MiB","22 B"],[10485760,10485738,22]]
    
In this case, the game would have approx. 10 MiB available, while 22 bytes are in use.