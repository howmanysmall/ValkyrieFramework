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
**Filename.mod.lua**: Module Script  
**Filename.loc.lua**: Local Script  
**Filename.lua**: Script  
**Filename.mod.moon**: Module Script (Moonscript)  
**Filename.loc.moon**: Local Script (Moonscript)  
**Filename.moon**: Script (Moonscript)  
**_.Filename.ext**: Represents the parent directory; replaces the build target in the CI  
**.Filename.ext**: A dot in front of a file name tells the CI to ignore the file.

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
the same). The reason for this is simple - If you're changing how the API functions,
you're going to cause API breaks.

How do I test my changes?
---
Create a pull request on this repository. Put "[WIP]" in the title to inform that it is not ready to merged.  
Go to the pull request's page. You should see that the CI has started to build it.  
After a few seconds you should see it finish and display either an error or success icon.  
If it's an error icon, click "Show all checks" and then "Details" and you should see what went wrong.  
If it's a success icon, go to [the list of models](https://ci.crescentcode.net/models) and pick the one that is yours.
Take the model. You should now be able to `require()` the model.  

If you want to update it, don't create a new pull request, but add commits to the already existing one instead.

How do I contribute?
---
Create a pull request, change the things you want, request to merge it to
bleeding-edge.
Do *not* put multiple changes into a single PR. Instead, create a separate branch
for each change and submit multiple PRs. For example:

* `sidebar-input-cues` -> Contains code that gives the Sidebar input cues
* `markdown-syntax-fix` -> Fixes syntax in README.md

Now, if I found out that there's a problem with the Sidebar code, I could still
merge `markdown-syntax-fix` without getting the bug in the upstream repository.

Where should I pull from?
---
Dev or bleeding-edge
