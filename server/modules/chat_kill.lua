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

local Tag = 'kill'
local usage = '!kill <player>'
local description = 'Kills a player.'

local hook = require 'nbamHook'

hook.Add('postinit', Tag, function()
	nBAM:RegisterChatCMD(Tag, usage, description, function (player, cmd, _, target)
		if not nBAM:HasPermission(player, Tag) then return end
		
		local targets = Player.Match(target)
		if #targets <= 0 then
			nBAM:PPrint(player, nBAM.Color.red, "No player found!")
			return
		elseif #targets > 1 then
			nBAM:PPrint(player, nBAM.Color.red, "Multiple players found:")
			for _, ply in next, targets do
				nBAM:PPrint(player, nBAM.Color.lred, " - " .. ply:GetName())
			end
			return
		end

		targets[1]:SetHealth(0)
	end)
end)