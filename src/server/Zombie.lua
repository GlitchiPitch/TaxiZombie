local temp = game.ServerStorage.ZombieTemp
local zombieItems = game.ServerStorage.Items

local event = game.ServerStorage.Events.DestroyingZombie

zombieItems = zombieItems:GetChildren()

local coinRange = {min = 10, max = 100}

local zombie = {}; zombie.__index = zombie
function zombie.new(spawnPoint: Vector3, target: Part)
	local self = setmetatable({
		model = temp:Clone(),
		spawnPoint = spawnPoint,
		target = target,
		coins = 0,
	}, zombie)
	
	
	self:init()
	
	return self
end

function zombie:init()
	self.model.Parent = workspace.Zombies
	self.model:MoveTo(self.spawnPoint)

	for i, v in zombieItems[math.random(#zombieItems)]:GetChildren() do
		local item = v:Clone()
		if item:IsA('Decal') then item.Parent = self.model:FindFirstChild('Head')
		else item.Parent = self.model end
	end
	
	local beam: Beam = self.model:FindFirstChild('Beam')
	local targetAttachment = self.target:FindFirstChild('BeamTargetAttachment')
	local board = self.model.Head:FindFirstChild('Cost')
	local targetValue = self.model:FindFirstChild('Target')
	targetValue.Value = self.target
	
	self.model.Destroying:Connect(function()
		event:Fire(self.coins)
	end)

	self.model:FindFirstChildOfClass('Humanoid').Seated:Connect(function(active)
		if active then
			local startPosition = self.model:GetPivot().Position
			beam.Enabled = true
			beam.Attachment1 = targetAttachment
			self.coins = math.floor((startPosition - self.target.Position).Magnitude)
			board.TextLabel.Text = self.coins .. '$'
			board.Enabled = true
		end
	end)
end

return zombie.new