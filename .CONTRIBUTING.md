Contributing to Valkyrie
===

Where do my files go?
---
*Where are they being used?*   
**Client only**: `/Client/`  
**Server only**: `/Core/`  
**Both**: `/Shared/`

*What kind of file are they?*  
**Component**: `./Components`  
**Library**: `./Libraries`

*What about /Libraries/ and /Server/?*  
Libraries was from the old structure, and has been kept simply because I can't
be bothered to use it. `/Server/` is used by the Valkyrie Core to run things when
it is loaded and attach them to Players when they join (If you need to use them,
put the files in `/Server/Template/`)

What's with the file names?
---
**\*.mod.lua**: Module Script  
**\*.loc.lua**: Local Script  
**\*.lua**: Script  
**_.\***: Represents the parent directory; replaces the build target in the CI

What can I add?
---
Anything that is not specific to a certain game or game style. Anything like
that would be better off being a seperate model that uses the Valkyrie API. You
shouldn't be messing with the Valkyrie cores or existing components unless you
see a flaw, in which case make a pull request and sort it out there.

Why can't I change the core?
---
Do you *want* to break things? If you're changing the core, only change how a 
process works; don't try and add new parts to the core API (Put them in a
component), and don't change how the API works schematically (Keep input/returns
the same)

How do I contribute?
---
Create a pull request, change the things you want, request to merge it to
bleeding-edge

Where should I pull from?
---
Dev or bleeding-edge