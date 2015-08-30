Library specification
===
Specification
---
All libraries must return a single function, which is called with a single
argument - The wrapper object. The functions are not expected to return anything
and any returns will be discarded. Unlike old iterations of the libraries, you
are no longer required to wrap your values manually inside of the function so
most values can be kept outside of the library function as upvalues, and the
function is no longer called with the same environment as the function it is
loading into.

Wrapper object
---
*The Wrapper object contains all the behaviour for the wrapped environment. Play
nice with it, because it can really mess up other libraries if you don't*
### Methods


**Override**
``` lua
Wrapper:Override(
  string Type
) -> {
  :Instance = function( [self]
    table OverridesList
  ) -> nil,
  __call = function( [self]
    table MetamethodsOverrides
  ) -> nil
}
```
Provides an interface for modifying the behaviour of Roblox datatypes, or adding
methods to certain Instance classes (Not currently supporting inheritence)  
*Note: All functions supplied take unwrapped arguments*  
`Wrapper:Override "Color3" {__index = function(t,k) return "No." end}`  
`Wrapper:Override "Player":Instance {Kill = function(p) p.Character:BreakJoints() end}`

---

**OverrideGlobal**
``` lua
Wrapper:OverrideGlobal(
  string GlobalName
) -> function(
  var Override
) -> nil
```
Interface for overriding certain areas of the global environment, on an \__index
basis. Tries to preserve as much behaviour from the value it is replacing as is
possible, including retaining any values not replaced in overrides where the
value it is replacing is a table or a userdata, and setting the \__call when the
replaced value is a function.  
`Wrapper:OverrideGlobal "Vector3" {Lerp = function(a,b,al) return a+(b-a)*al end}`

---

**mod**
``` lua
Wrapper:mod(
  var from,
  var ?to
) -> nil
```
Interface for safely modifying the wrap and unwrap targets for a value, making
the wrapper treat value `from` as value `to`, even if `to` is nil. Very handy.  
`Wrapper:mod(game:GetService("DataStoreService"), nil)`

---

**GenExt**
``` lua
Wrapper:GenExt(
  function(...) f
) -> function(...) ext
```
Creates an inverted function wrapper. Whereas normal function wrapping returns a
function with unwrapped arguments and wrapped returns, the inverted function has
wrapped arguments and inverted returns. Good for modules, useless for anything
else.

---

**wrap**
``` lua
Wrapper:wrap(
  var Value
) -> var WrappedValue
```
Wraps `Value` as `WrappedValue`, pretty self-explanatory. If `Value` is already
a wrapper, it might take the liberty of spitting `Value` back out at you.

---

**wrapAll**
``` lua
Wrapper:wrapAll(
  ... Values
) -> ...
```
Variadic form of `wrap`

---

**unwrap**
``` lua
Wrapper:unwrap(
  var Value
) -> var UnwrappedValue
```
Unwraps `Value`, returning the unwrap target for the value (Or `Value` if no
unwrap target exists for it)

---

**unwrapAll**
``` lua
Wrapper:unwrapAll(
  ... Values
) -> ...
```
Variadic form of unwrap

---

**_rawConvert**  
*Not a method*
``` lua
_rawConvert(
  table from,
  table to,
  (table,userdata) wrapper,
  var Value
) -> var convertedValue
```
The raw convert method that the wrapper uses. Standard wrap uses `ulist` for the
`from` argument, and `wlist` for the `to` argument (With itself as `wrapper`).
Doesn't really have much use to anyone but the most advanced users, because it
can really break stuff when used manually.

### Other Members (Properties)


**ulist**
``` lua
{unwrapper = true; ref = ({},{__mode = 'k'})}
```
Contains the unwrap targets for values. `unwrap ref[k] -> v`  
`wrapper.ulist.ref[someWrappedValue] = somePureValue`

---

**wlist**
``` lua
{unwrapper = false; ref = ({},{__mode = 'v'})}
```
Contains the wrap targets for values. `wrap ref[k] -> v`  
`wrapper.wlist.ref[somePureValue] = someWrappedValue`

---

**Overrides**
``` lua
{
  Globals = {};
  Types = {};
  Instance = {};
}
```
Contains the overrides for global values, Roblox types and Instance types.

---

**mt**
``` lua
{
  __len       = function(a) return a end;
  __unm       = function(a) return a end;
  __add       = function(a,b) return a+b end;
  __sub       = function(a,b) return a-b end;
  __mul       = function(a,b) return a*b end;
  __div       = function(a,b) return a/b end;
  __mod       = function(a,b) return a%b end;
  __pow       = function(a,b) return a^b end;
  __lt        = function(a,b) return a < b end;
  __eq        = function(a,b) return a == b end;
  __le        = function(a,b) return a <= b end;
  __concat    = function(a,b) return a..b end;
  __call      = function(t,...) return t(...) end;
  __tostring  = tostring;
  __index     = function(t, k) return t[k] end;
  __newindex  = function(t, k, v) t[k] = v end;
}
```
Contains all the default metamethods for wrapped values, in wrapped form. Also
the metatable for wrapped tables.

---

**imt**
``` lua
current = ({},{__mode = 'k'})
{
  __len = function(a) return #a:GetChildren() end;
  __call = function(a,_,n)
    if not current[a] then current[a] = a:GetChildren() end;
    local k,v = next(current[a], n);
    if not k then current[a] = nil; end;
    return k,v
  end;
  __index = function(t,k)
    local c = t.ClassName;
    return self.Overrides.Instance[c][k] or t[k]
  end;
}
```
Contains the metamethod overrides for Instance values. It's really not advised
to mess with this bit manually unless you have a good reason to.

---

**umt**
``` lua
({},{})
```
Defaultly blank table that contains the metamethod overrides for values with
custom types.

---

**TypeIdentities**
``` lua
_G.TypeIdentities or ({},{__mode = 'k'})
```
Contains the identities for custom types. If you've loaded the DataTypes
component before loading this library (Or generating this Wrapper), then it will
take the identities from there.

---

**TypeChecks**
``` lua
({},{})
```
Contains functions that are pcalled to check a type. If you're Overriding a
datatype, then you may want to make sure that a check function exists for that
type.

---

**genSeed**
``` lua
tick()
```
Literally contains the tick that the Wrapper was made. I think I'd intended on
using it somewhere, but apparently I'm not.
