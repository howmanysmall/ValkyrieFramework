Main/Alt Objects
===
In AppbarModule, Icons and Text Objects always have a Main and an Alt instance.
Main Objects are the ones being displayed and Alt Objects are the one to be 
tweened in.

The following picture should illustrate how they work:

![Main/Alt Object Illustration](http://i.imgur.com/FmX0NpC.png)

They are swapped around when functions such as `:ChangeIcon()` or `:ChangeText()` are called *before* tweening.
However, the module takes care of naming them correctly internally.