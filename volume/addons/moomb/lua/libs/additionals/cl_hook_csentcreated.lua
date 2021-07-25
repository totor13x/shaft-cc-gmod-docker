local _oldClientsideModel = ClientsideModel
ClientsideModel = function(model, render)
	-- print(model)
	local CSEnt = _oldClientsideModel(model, render)
	
	hook.Run('OnCSEntCreated', model, CSEnt)
	
	return CSEnt
end 