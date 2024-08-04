
local events = game.ServerStorage.Events
local server = game.ServerScriptService.Server
local shared = game.ReplicatedStorage.Shared
local types = require(shared.Types)
local zombie = require(server.Zombie)
local carSpawner = require(server.CarSpawner)

local map = workspace.Map :: types.Map
local spawnPlate = map.SpawnPlate
local targets = map.Targets:GetChildren()

local playerStats

function setupMap()
	
	for i, v in targets do
		v.Touched:Connect(function(hit)
			if not hit.Parent then return end
			local hum = hit.Parent:FindFirstChild('Zombie')
			local target = hit.Parent:FindFirstChild('Target')
			if not hum or not target then return end
			if target.Value == v then
				hum.Parent:Destroy()
			end
		end)
	end
end

function setupZombie()
	local spawnPositions = {
		x = { min = spawnPlate.Position.X - spawnPlate.Size.X / 2, max = spawnPlate.Position.X + spawnPlate.Size.X / 2},
		y = spawnPlate.Position.Y,
		z = { min = spawnPlate.Position.Z - spawnPlate.Size.Z / 2, max = spawnPlate.Position.Z + spawnPlate.Size.Z / 2},
	}
	
	local spawnPoint = Vector3.new(math.random(spawnPositions.x.min, spawnPositions.x.max), spawnPositions.y, math.random(spawnPositions.z.min, spawnPositions.z.max))
	local target = targets[math.random(#targets)]
	zombie(spawnPoint, target)
end

function spawnZombies()
	while task.wait(math.random(5)) do 
        if #workspace.Zombies < 50 then
            setupZombie()
        end
    end
end

function onPlayerAdded(player:Player)
	playerStats = game.ServerStorage.leaderstats:Clone()
	playerStats.Parent = player
	playerStats = playerStats.Cash
    carSpawner.init(player)
	setupMap()
	spawnZombies()
end

function getCash(coins: number)
	playerStats.Value += coins
end



game.Players.PlayerAdded:Connect(onPlayerAdded)
events.DestroyingZombie.Event:Connect(getCash)