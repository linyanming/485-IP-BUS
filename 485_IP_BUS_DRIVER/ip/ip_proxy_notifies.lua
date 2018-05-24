--[[=============================================================================
    Notification Functions

    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.ip_proxy_notifies = "2018.05.23"
end

--[[
function NOTIFY.PROPERTY_DEFAULTS(bindingID, tPropertyDefaults)
	LogTrace("NOTIFY.PROPERTY_DEFAULTS")

	SendNotify("PROPERTY_DEFAULTS", tPropertyDefaults, bindingID)
end
]]
