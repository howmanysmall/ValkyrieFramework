local RPC = script:WaitForChild"RPC";

RPC.OnClientEvent:connect(function(r,...)
    if r == 'ProtectValue' then
        local val = ...
        if val then
            val.Changed:connect(function(v)
                RPC:FireServer("ValueChanged", val, v);
            end)
        end;
    end;
end);

spawn(function()
    while wait(1) do
        if workspace:GetRealPhysicsFPS() > 65 then
            RPC:FireServer("PhysicsFps");
        end;
    end
end);
