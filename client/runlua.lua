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

local function iscolor (col)
	return type(col) == 'userdata' and type(col.r) == 'number'
		and type(col.g) == 'number' and type(col.b) == 'number'
		and type(col.a) == 'number'
end

cprint = function (c, ...)
	local color
	if iscolor(c) then
		color = c
		c = nil
	else
		color = Color(0xFF, 0xFF, 0xFF, 0xFF)
	end
	
	local print_string
	for _, v in next, {c, ...} do
		print_string = (print_string or "") .. tostring(v)
	end
	
	if not print_string then print_string = "<Empty Value>" end
	
	Chat:Print(print_string, color)
end

Network:Subscribe("nBAM_runlua", function (script)
	script = load(script)
	
	easylua.Start(LocalPlayer)
	local ok, err = pcall(script)
	easylua.End()
	
	if not ok then
		cprint(Color(255, 190, 190), err)
	end
end)