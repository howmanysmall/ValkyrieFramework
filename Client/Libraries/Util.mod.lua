local wrap, unwrap;
--------------------------------------------------------------------------------
--||                            Utility library                             ||--
--|| ---------------------------------------------------------------------- ||--

local newI = Instance.new;
local nv3 = Vector3.new;

return function(Override, OverrideGlobal, wlist, ulist)
    local _ENV = getfenv(1);
    wrap, unwrap = wrap, unwrap;
    new = function(Type)
        assert(type(Type) == 'string', "You must be using a string", 2);
        return setmetatable({
            Instance = function(props)
                assert(type(props) == 'table' or type(props) == 'nil', "You must supply a table of properties", 2);
                local i = newI(Type);
                for k,v in next,props do
                    if type(k) == 'number' then
                        i.Parent = unwrap(v);
                    else
                        i[k] = unwrap(v);
                    end
                end
                return wrap(i);
            end
            },{__call = function(_, ...)
                return wrap(_ENV[Type].new(...));
            end
        });
    end;
    OverrideGlobal "Vector3" {
        Up = nv3(0,1,0);
        Down = nv3(0,-1,0);
        Front = nv3(0,0,-1);
        Back = nv3(0,0,1);
        Left = nv3(-1,0,0);
        Right = nv3(1,0,0);
        Zero = nv3(0,0,0);
        One = nv3(1,1,1);
    };
end;
