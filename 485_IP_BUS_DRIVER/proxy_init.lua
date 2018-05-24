--[[=============================================================================
    Initialization Functions

    Copyright 2017 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "ip.ip_proxy_class"
require "ip.ip_proxy_commands"
require "ip.ip_proxy_notifies"

IP_DEVICES_ADDR = {}
DEVICE_ADDR = {}
-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_init = "2017.01.13"
end

function ON_DRIVER_EARLY_INIT.proxy_init()
	-- declare and initialize global variables
end

function ON_DRIVER_INIT.proxy_init()
	-- connect the url connection
	--ConnectURL()
	gIsNetworkConnected = true
	SetControlMethod()

	-- instantiate the camera proxy class
	gIpProxy = IpProxy:new(DEFAULT_PROXY_BINDINGID)
end

function ON_DRIVER_LATEINIT.proxy_init()
--    C4:urlSetTimeout (20)

--	gCameraProxy:dev_PropertyDefaults()
end

function IP_DEVICES_ADDR.init()

    local i = 0
    local devid = C4:GetDeviceID()     
    local devs = C4:GetBoundConsumerDevices(devid , 1)   
    if (devs ~= nil) then
    for id,name in pairs(devs) do
	   print ("id " .. id .. " name " .. name)
	   DEVICE_ADDR[i] = id
	   i = i + 1
    end
    end
end
