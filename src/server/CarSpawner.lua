local shared = game.ReplicatedStorage.Shared
local types = require(shared.Types)

local carSpawner = workspace.CarSpawner :: types.CarSpawner
local station = carSpawner.Station
local button = carSpawner.Button
local model = station.Car
local backup = model:Clone()

function onTouch(hit: Part)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and not station:FindFirstChild('Car') then
        button.CanTouch = false
		task.wait(1)
		model = backup:Clone()
		model.Parent = station
        button.CanTouch = true
	end
end

function deleteCar(player: Player)
    player.CharacterAdded:Connect(function(character: Model)
        character.Humanoid.Died:Connect(function()
            model:Destroy()
        end)
    end)
end

function init(player: Player)
    button.Touched:Connect(onTouch)
    deleteCar(player)
end

return {
    init = init,
}