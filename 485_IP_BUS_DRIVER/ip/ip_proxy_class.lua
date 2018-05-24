--[[=============================================================================
    IP Proxy Class

    Copyright 2018 Hiwise Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.ip_proxy_class = "2018.05.23"
end

IpProxy = inheritsFrom(nil)

function IpProxy:construct(bindingID)
	-- member variables
	self._BindingID = bindingID

	self:Initialize()

end

function IpProxy:Initialize()
	-- create and initialize member variables
	self._Address = "localhost"
	self._TcpPort = 80
	self._UdpPort = 554
	self._Username = "username"
	self._Password = "password"
end



--[[=============================================================================
    Camera Proxy Commands(PRX_CMD)
===============================================================================]]
--[[
function CameraProxy:prx_SET_ADDRESS(tParams)
	tParams = tParams or {}
	self._Address = tParams["ADDRESS"] or self._Address
end

function CameraProxy:prx_SET_ADDRESS(tParams)
	tParams = tParams or {}
	self._Address = tParams["ADDRESS"] or self._Address
end
]]



--[[=============================================================================
    Camera Proxy UIRequests
===============================================================================]]
--[[
	Return the query string required for an HTTP image push URL request.
--]]
--[[
function CameraProxy:req_GET_SNAPSHOT_QUERY_STRING(tParams)
	tParams = tParams or {}
    local size_x = tonumber(tParams["SIZE_X"]) or 640
    local size_y = tonumber(tParams["SIZE_Y"]) or 480

	return "<snapshot_query_string>" .. C4:XmlEscapeString(GET_SNAPSHOT_QUERY_STRING(size_x, size_y)) .. "</snapshot_query_string>"
end

]]

--[[=============================================================================
    Camera Proxy Notifies
===============================================================================]]
--[[
function CameraProxy:dev_PropertyDefaults()
	local property_defaults = {}
	property_defaults.HTTP_PORT = C4:GetCapability("default_http_port") or 80
	property_defaults.RTSP_PORT = C4:GetCapability("default_rtsp_port") or 554
	property_defaults.AUTHENTICATION_REQUIRED = C4:GetCapability("default_authentication_required") or true
	property_defaults.AUTHENTICATION_TYPE = C4:GetCapability("default_authentication_type") or "BASIC"
	property_defaults.USERNAME = C4:GetCapability("default_username") or "username"
	property_defaults.PASSWORD = C4:GetCapability("default_password") or "password"

	NOTIFY.PROPERTY_DEFAULTS(self._BindingID, property_defaults)
end

]]
--[[=============================================================================
    Camera Proxy Functions
===============================================================================]]
-- Create class functions required by the class
--[[
function CameraProxy:BuildHTTPURL(queryString)
	local httpUrl = ""
	
	if ((queryString ~= nil) and (string.len(queryString) > 0)) then
		httpUrl = "http://" .. self._Address .. ":" .. self._HttpPort .. "/" .. queryString
	end
	
	return httpUrl
end

]]


