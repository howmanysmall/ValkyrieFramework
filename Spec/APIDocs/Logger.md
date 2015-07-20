# Logger

Logger is a component used for elegant logging.  
Example usage:
```lua
Logger:Tag "AnimationManager":Info "Playing 'walking' animation!";
```

## Formatting Method
Messages are formatted using the following algorithm:
```lua
local function FormatMessage(self, ...)
    local Formatted     = FORMAT;
    Formatted           = Formatted:gsub("\1", LEVEL);
    Formatted           = Formatted:gsub("\2", table.concat(TAGS, ", "));
    Formatted           = Formatted:gsub("\3", table.concat({...}, "\t")); -- All arguments tostring'd.
    return Formatted;
end
```
The default format is `[\1 ~ \2] ~ \3`. All output goes through TestService (except for Debug/Verbose, which go through `print()` but are formatted in a similar way)
This means, the above example code would produce the following output by default:
```
15:37:52.692 - TestService: [Info ~ AnimationManager] ~ Playing 'walking' animation!
```

## Methods

### Printing Methods
All of these methods do the following process:

1. Are there arguments? If not, set the level and return a new Logger.
2. Is the `LastCondition` flag false? If yes, set it to true and quit.
3. Print the formatted message (See "Formatting Method")
4. Is the `StopScript` flag set? If yes OR the logging level is Error or Fatal, stop the script.
5. Unset the `StopScript` flag
6. Return the current Logger.


**Debug**
```lua
Logger:Debug(
	?var Arg1, 
	?var Arg2, 
	?...
) -> Logger
```
This function prints a black, formatted message to the output. See "Formatting Method".

**Verbose**
See "Debug".

**Warn**
Logger:Warn(
	?var Arg1, 
	?var Arg2, 
	?...
) -> Logger
```
This function prints a yellow, formatted message to the output. See "Formatting Method".

**Error**
Logger:Error(
	?var Arg1, 
	?var Arg2, 
	?...
) -> Logger
```
This function prints a red, formatted message to the output. See "Formatting Method".

**Fatal**
See "Error".

### Other methods

**Tag**
```lua
Logger:Tag(
	string Tag1, ?
	string Tag2, 
	?...
) -> Logger
```

This function returns a Logger object with the tags.

**UnTag**
```lua
Logger:UnTag(
	string Tag1, 
	?string Tag2, 
	?...
) -> Logger
```

This function returns a Logger object with the tags removed.

**If**
```lua
Logger:If(
	bool Condition
) -> Logger
```
This function returns a Logger object with the `LastCondition` flag set to `Condition`.

**SetStopScriptFlag**
```lua
Logger:SetStopScriptFlag(
	bool Flag
) -> Logger
```

This function returns a Logger object with the `StopScript` flag set to `Flag`.