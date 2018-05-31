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

function EX_CMD.SENDCMD(tParams)
	LogTrace("EX_CMD.SENDCMD")
	LogTrace(tParams)
	local msg = tParams["COMMAND"]
	local tmp_msg = ""
	if(msg ~= nil and msg ~= "") then
	    local msglen = #msg/2
	    local message = string.lower(msg)
	    for i = 1,msglen do
	        local temp = 0
	        local tab = (i - 1)*2 + 1
            if(string.byte(message,tab) >= string.byte("a")) then
                temp = temp + (string.byte(message,tab) - string.byte("a") + 10) * 16
            else
                temp = temp + (string.byte(message,tab) - string.byte("0")) * 16
            end
            if(string.byte(message,tab+1) >= string.byte("a")) then
                temp = temp + (string.byte(message,tab+1) - string.byte("a") + 10)
            else
                temp = temp + (string.byte(message,tab+1) - string.byte("0"))
            end            
            print(temp)
            tmp_msg = tmp_msg .. string.pack("b",temp)
	    end
	    hexdump(tmp_msg)
	 --   if(gIpProxy._MsgTable[gIpProxy._MsgPos] == nil or gIpProxy._MsgTable[gIpProxy._MsgPos] == "") then
		   gIpProxy._MsgTable[gIpProxy._MsgPos] = tmp_msg
		   if(gIpProxy._MsgPos == gIpProxy._MsgTableMax) then
			  gIpProxy._MsgPos = 1
		   else
			  gIpProxy._MsgPos = gIpProxy._MsgPos + 1
		   end
	 --   end
	  --  gCon:SendCommand(tmp_msg,1,"SECONDS","LED_CONTROL")
	end

	
end

function EX_CMD.SYNCDEV(tParams)
	LogTrace("EX_CMD.SYNCDEV")
	LogTrace(tParams)
	local device_id = tParams["DEVICE_ID"]
	KEYPAD_DEVICE.SYNC_MODE = true
	KEYPAD_DEVICE.SYNC_DEVID = device_id
end