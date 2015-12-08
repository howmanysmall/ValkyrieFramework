# Valkyrie Framework
## What is Valkyrie?
Valkyrie is a project designed to change how developers make things, changing how they interact with other models and their Players. 
Libraries provide people an interface to do the things they want, faster and easier, by injecting the Valkyrie wrapper under the code so that you can write what makes sense to you and Valkyrie will handle everything else. 
Components provide a collection of modules that only load when you need them, and can be accessed through Valkyrie. From a complete set of the [Material palette](https://www.google.com/design/spec/style/color.html), to a way to connect to events without worrying about them existing in the first place, Valkyrie should have you covered. 

Valkyrie has its own overlay in development, which will allow players to connect more with the game and the community, by being able to access several Valkyrie cross-game features from within the game, such as seeing what achievements they've been given in the game through Valkyrie, or what their friends are up to and joining their game or their server instance (If valid and permitted by the game) without ever leaving the game.

## Where do I get it?
For a list of models, please visit [The CI server](https://gskw.dedyn.io:444/models).
To check the build log of a model, go to the [branches list](https://github.com/ValkyrieRBXL/ValkyrieFramework/branches) and click the icon next to the branch you want to inspect.

## How do I use it?
Just `require()` the Valkyrie model and then call the returned Valkyrie object with `(GameName, Key)` to auth it and link it to your Valkyrie identity.

### Where is the API?
The API documentation is currently in the making, but some docs are available in `/.Spec/APIDocs`

## How can I help?
Test. Valkyrie always needs testing, so grab a model and load it up. Play with the components, and try to make something with it, then if you find a bug submit an issue to the bug tracker with a stack trace from the output, the branch it came from, and how to replicate.

Please read [CONTRIBUTING.md](https://github.com/ValkyrieRBXL/ValkyrieFramework/blob/bleeding-edge/CONTRIBUTING.md) if you want to contribute code to the repository.

## Acknowledgements
This project uses the Font Rendering Module by [EgoMoose](http://www.roblox.com/users/2155311/profile) as a base for its font rendering. (on the font-rendering branch)
