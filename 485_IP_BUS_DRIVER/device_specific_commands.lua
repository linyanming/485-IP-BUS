--[[=============================================================================
    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_specific_commands = "2016.01.08"
end

--[[=============================================================================
    ExecuteCommand Code

    Define any functions for device specific commands (EX_CMD.<command>)
    received from ExecuteCommand that need to be handled by the driver.
===============================================================================]]
--function EX_CMD.NEW_COMMAND(tParams)
--	LogTrace("EX_CMD.NEW_COMMAND")
--	LogTrace(tParams)
--end

function EX_CMD.SENDDEV(tParams)
	LogTrace("EX_CMD.SENDDEV")
	LogTrace(tParams)
	gCon:SendCommand("HELLO WORLD",1,"SECONDS","normal")
end