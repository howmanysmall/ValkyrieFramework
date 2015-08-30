# Communication specifications #

## Basic requests ##
Basic requests to the services would look like this:

    http://gskw.noip.me:5678/[module]/[function]/[gid]/[cokey]
    
The POST body would contain the arguments passed to the function, in the
Valkyrie service format.

## Basic responses ##
Basic responses from the services return data encoded in the Valkyrie service
format.

## Valkyrie service format ##

### Types ###
The arguments may be one of the following types:

- `int`     (example: 12345)
- `float`   (example: 1.0)
- `string`  (example: "asdfasd")
- `boolean` (example: true)
- `array`   (example: [123,"asdf"])

Strings may contain any charaters, but __quote marks and slashes inside the
strings must be escaped with a slash__.

### Formatting ###
Data is encoded in a `key=value;key2=value2` scheme. You don't have to add a ;
after the last value.

Let's say, we have the following list of stuff we want to encode (in Lua):

- index         = 9123
- username      = "Shedletsky"
- save          = {11.7, "Matt224"}

The resulting string would be:

    index=9123;username="Shedletsky";save=[11.7,"Matt224"]
    
## Example request ##
Let's say, we want to call a function called `save_stats` in a module called
`database_manager`, and we want to pass the following arguments (Lua format):

- return        = true
- requester     = "stravant"
- stats         = {7, 6, 1.16666666667, true, "Hello"}

The request URL would look like this:

    http://gskw.noip.me:5678/database_manager/save_stats/exampleGID/
    exampleCoKey

And the POST body would look like this:

    return=true;requester="stravant";stats=[7,6,1.16666666667,true,"Hello"]