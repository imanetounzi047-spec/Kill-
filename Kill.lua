-- Comando server: ";kill me" -> suicidar al jugador
-- Coloca este Script en ServerScriptService

local Players = game:GetService("Players")
local COOLDOWN = 2 -- segundos entre usos por jugador

local lastUse = {} -- tabla para trackear cooldowns por UserId

local function handleChat(player, message)
	if not message then return end
	-- normalizar: quitar espacios externos y pasar a minúsculas
	local text = message:lower():gsub("^%s+",""):gsub("%s+$","")
	-- comprobar patrón exacto ";kill me" permitiendo cualquier cantidad de espacios entre palabras
	if text:match("^;kill%s+me$") then
		local uid = player.UserId
		local now = tick()
		if lastUse[uid] and now - lastUse[uid] < COOLDOWN then
			-- en cooldown, ignorar
			return
		end
		lastUse[uid] = now

		local char = player.Character or player.CharacterAdded:Wait()
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			humanoid.Health = 0
		end
	end
end

local function onPlayer(player)
	player.Chatted:Connect(function(msg)
		pcall(handleChat, player, msg)
	end)
end

-- Conectar jugadores actuales y futuros
for _, p in ipairs(Players:GetPlayers()) do
	onPlayer(p)
end
Players.PlayerAdded:Connect(onPlayer)
