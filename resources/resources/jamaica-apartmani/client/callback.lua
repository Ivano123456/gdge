local RequestId = 0
local serverRequests = {}

TriggerServerCallback = function(eventName, callback, ...)
    serverRequests[RequestId] = callback

    TriggerServerEvent(GetCurrentResourceName() .. "triggerServerCallback", eventName, RequestId, ...)

    RequestId = RequestId + 1
end

RegisterNetEvent(GetCurrentResourceName() .. "serverCallback", function(requestId, ...)
	if serverRequests[requestId] == nil then
		return
	end
    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)