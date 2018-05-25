--[[=============================================================================
    Get, Handle and Dispatch message functions

    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_messages = "2016.01.08"
end

--[[=============================================================================
    GetMessage()
  
    Description:
    Used to retrieve a message from the communication buffer. Each driver is
    responsible for parsing that communication from the buffer.
  
    Parameters:
    None
  
    Returns:
    A single message from the communication buffer
===============================================================================]]
function GetMessage()
	local message = ""
	
	if ((gReceiveBuffer ~= nil) and (gReceiveBuffer ~= "")) then
	   
		--TODO: Implement a routine which will parse out a single message
		--      from the receive buffer(gReceiveBuffer)
		if(#gReceiveBuffer >= KEYPAD_DEVICE.DATA_LEN) then
		   KillTimer(gIpProxy._Timer)
		   message = string.sub(gReceiveBuffer,1,KEYPAD_DEVICE.DATA_LEN)
		   gReceiveBuffer = string.sub(KEYPAD_DEVICE.DATA_LEN+1,#gReceiveBuffer)
	     else
		   StartTimer(gIpProxy._Timer)
	     end
		hexdump(message)
		return message
	end

	--TODO: Once a complete message is found in the buffer remove it and 
	--      return the message
	gReceiveBuffer = ""

	return message
end

--[[=============================================================================
    HandleMessage(message)]

    Description
    This is where we parse the messages returned from the GetMessage()
    function into a command and data. The call to 'DispatchMessage' will use the
    'name' variable as a key to determine which handler routine, function, should
    be called in the DEV_MSG table. The 'value' variable will then be passed as
    a string parameter to that routine.

    Parameters
    message - Message string containing the function and value to be sent to DispatchMessage

    Returns
    Nothing
===============================================================================]]
function HandleMessage(message)
	if (type(message) == "table") then
		LogTrace("HandleMessage. Message is ==>")
		LogTrace(message)
		LogTrace("<==")
	else
		LogTrace("HandleMessage. Message is ==>%s<==", message)
		hexdump(message)
		local msg_data = {}
		for i = 1,#message do
		   msg_data[i] = string.byte(message,i)
		   print(i .. ":" .. msg_data[i])
	     end
		if(msg_data[1] == 0x55 and msg_data[2] == 0x2a and msg_data[3] == 0x30) then
		   local sum = 0
		   for i = 1,7 do
		       sum = sum + msg_data[i]
		   end
		   if(bit.band(sum,0xff) == msg_data[8]) then
			  local dev_id = bit.band(msg_data[4],0xf8)/8
			  local btn_id = bit.band(msg_data[4],0x07)
			  LogTrace("dev_id = %d btn_id = %d", dev_id,btn_id)
			  if(DEVICE_ADDR[dev_id] ~= nil) then
				 LogTrace("DEVICE_ADDR[dev_id] ~= nil")
				 if(KEYPAD_DEVICE.SYNC_MODE == true) then
				    LogTrace("SYNC SUCCESS 1")
				    DEVICE_ADDR[dev_id] = KEYPAD_DEVICE.SYNC_DEVID
					KEYPAD_DEVICE.SYNC_MODE = false
					KEYPAD_DEVICE.SYNC_DEVID = 0
				 else
				     local devid = C4:GetDeviceID()     
				     local devs = C4:GetBoundConsumerDevices(devid , 1)   
					 local connected = false
					 print("devid = " .. devid)
					 
				     if (devs ~= nil) then
					    LogTrace("devs ~= nil")
					    for id,name in pairs(devs) do
					       print("id = " .. id .. " ".. type(id) .. "name = " .. name)
					       print("DEVICE_ADDR[dev_id] = " .. DEVICE_ADDR[dev_id])
						   if(tostring(id) == DEVICE_ADDR[dev_id]) then
							  LogTrace("connected == true")
						       connected = true
							  break
						   end
					    end
				     end
					if(connected == true) then
					    LogTrace("SEND BUTTON PRESS")
					    C4:SendToDevice(DEVICE_ADDR[dev_id],"BTNPRESS",{BUTTON_ID = btn_id})
				     else
					    LogTrace("connected == false")
					    DEVICE_ADDR[dev_id] = nil
				     end
				     KEYPAD_DEVICE.SYNC_MODE = false
				     KEYPAD_DEVICE.SYNC_DEVID = 0
				 end
			  else
			      if(KEYPAD_DEVICE.SYNC_MODE == true) then
			        LogTrace("SYNC SUCCESS 2")
				    DEVICE_ADDR[dev_id] = KEYPAD_DEVICE.SYNC_DEVID
					KEYPAD_DEVICE.SYNC_MODE = false
					KEYPAD_DEVICE.SYNC_DEVID = 0
				 else
				     LogTrace("KEYPAD_DEVICE.SYNC_MODE == false")
				 end
			  end
		   else
			  LogTrace("Data check fail")
		       gReceiveBuffer = ""
		   end
	     else
		   LogTrace("Data check fail 2")
		end
	end

	-- TODO: Parse messages and DispatchMessage

	--DispatchMessage(name, value)
end

--[[=============================================================================
    DispatchMessage(MsgKey, MsgData)

    Description
    Parse routine that will call the routines to handle the information returned
    by the connected system.

    Parameters
    MsgKey(string)  - The function to be called from within DispatchMessage
    MsgData(string) - The parameters to be passed to the function found in MsgKey

    Returns
    Nothing
===============================================================================]]
function DispatchMessage(MsgKey, MsgData)
	if (DEV_MSG[MsgKey] ~= nil and (type(DEV_MSG[MsgKey]) == "function")) then
		LogInfo("DEV_MSG.%s:  %s", MsgKey, MsgData)
		local status, err = pcall(DEV_MSG[MsgKey], MsgData)
		if (not status) then
			LogError("LUA_ERROR: %s", err)
		end
	else
		LogTrace("HandleMessage: Unhandled command = %s", MsgKey)
	end
end
