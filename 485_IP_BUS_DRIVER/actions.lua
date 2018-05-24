--[[=============================================================================
    Lua Action Code

    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.actions = "2016.01.08"
end

-- TODO: Create a function for each action defined in the driver

function LUA_ACTION.TemplateVersion()
	TemplateVersion()
end


function LUA_ACTION.PrintVolumeCurve()
    print("===== Volume Curve =====")
    for j,k in pairs(tVolumeCurve) do
	   print(j,k)
    end
end

function LUA_ACTION.SendToTCP(tParams)
	print("send to tcp")
	for cmd,cmdv in pairs(tParams) do
	   if(cmd == "MSG" and cmdv ~= nil) then
		  gCon:SendCommand(cmdv,1,"SECONDS","normal")
		  break
	   end
     end
	
end

function LUA_ACTION.Sync(tParams)
    print("sync device")
    IP_DEVICES_ADDR.init()
end
