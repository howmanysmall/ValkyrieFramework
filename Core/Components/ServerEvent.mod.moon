--//
--// * Long-Polling events for Valkyrie Server
--// 

-- Give interface
-- Always listen for events
-- On event from server, listen again and fire related event
-- in the interface.
-- Interface __index spawns and caches a new Event object 
-- when invoked. Events are invoked by long-polling.
