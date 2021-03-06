--[[
  Copyright 2014 - The nBAM Team
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
  http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
]]--

local hook = require 'nbamHook'
local json = require 'dkjson'

local fn		 = 'permissions.txt'
local fn_default = 'permissions.default.txt'


local function errmsg (paramNum, expectedType)
	return string.format('Parameter #%d expected to be %s!', paramNum, expectedType)
end

hook.Add('preinit', 'permissions', function ()
	function nBAM:HasPermission (what, module)
		assert(self:IsString(what) or self:IsPlayer(what) or self:IsSteamId(), errmsg(1, 'string, player or steamid'))
		assert(self:IsString(module), errmsg(2, 'string'))
		
		local group
		
		if self:IsString(what) then
			group = what
		else
			group = self:GetGroup(what)
		end
		
		if not self:IsTable(self.permissions) or not self:IsTable(self.permissions[group]) then return end
		
		for _, permission in next, self.permissions[group] do
			if permission == module then return true end
		end
		
		return false
	end
end)

hook.Add('postinit', 'permissions', function (self)
	self.permissions = {}
	
	local fh = io.open(fn, 'r')

	if not fh then
		nBAM:Log('permissions', string.format("Could not find '%s', loading default permissions file...", fn))
		fh = io.open(fn_default, 'r')
		if not fh then
			nBAM:Log('permissions', 'Error: Could not open admin lists!')
			return
		end
	end
	
	local data = fh:read("*all")
	fh:close()
	
	data = json.decode(data)
	
	if not nBAM:IsTable(data) then
		nBAM:Log('permissions', 'Error in json file!')
		return
	end
	
	self.permissions = data.permissions or {}
end)