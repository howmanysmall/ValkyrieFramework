Settings
===
Settings are gettable using Valkyrie:GetComponent("Settings")
This returns the Settings userdata, which has the handles for modifying certain
areas of the Valkyrie components, or even non-Valkyrie components
    
    Base:
    class Settings {
      function RegisterSetting(
        string Name,
        table {
          function(var Value) set,
          function() get
        } GetSetHandle
      ) -> void,
      function GetSetting(
        string Name
      ) -> Setting[Name].get(),
      function SetSetting(
        string Name,
        var Value
      ) -> void
    }

Server
---

    Settings {
      Core = new Settings;
      Components = {
        ComponentName = new Settings;
      };
      ?Plugins = {
        PluginName = new Settings;
      };
      Custom = new Settings;
    }
    
Storing the server settings, these contain per-component settings and at some
point, also plugin settings and things like that. Core contains all the Settings
for the current game, and should probably be registered to a DataStore.

Client
---

    Settings {
      Interface = new Settings;
      User = new Settings;
      Custom = new Settings;
      Components = {
        ComponentName = new Settings;
      };
    }
    
Containing the user settings, this contains details such as which interface
components are visible, the user locale settings (User should be linked with the
user preferences on the Valkyrie servers), and other bindable settings for stuff
either from external sources wanting to unify their settings in Valkyrie.