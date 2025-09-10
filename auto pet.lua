print('Exec')
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.Backpack

local Services = setmetatable({}, {
	__index = function(self, Ind)
		local Success, Result = pcall(function()
			return cloneref(game:GetService(Ind) :: any)
		end)
		if Success and Result then
			rawset(self, Ind, Result)
			return Result
		end
		return nil
	end
})

local ReplicatedStorage: ReplicatedStorage = Services.ReplicatedStorage
local Players: Players = Services.Players
local Player = Players.LocalPlayer

local DataService = require(ReplicatedStorage.Modules.DataService):GetData()
local PetsData = DataService.PetsData.PetInventory.Data
local GiftPetRemote: RemoteEvent = ReplicatedStorage.GameEvents.PetGiftingService
local FavoriteRemote: RemoteEvent = ReplicatedStorage.GameEvents.Favorite_Item
local InventoryEnums = require(ReplicatedStorage.Data.EnumRegistry.InventoryServiceEnums)


getgenv().Config = {
    MAIN = "",
    LIST_CLONE = {},
    AMOUNT = 3,
    MIN_AGE = 10,
    MAX_AGE = 20
}

local Config = getgenv().Config
local cloneSent = {}

function waitUntilDone(item)
    for _ = 1, 400 do
        if not item.Parent then return true end
        task.wait(0.1)
    end
    return nil
end

Player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

function PrintDebug(...)
    print(string.format('[DEBUG] %s', tostring(...)))
end

if Player.Name ~= Config.MAIN then
    Player:Kick('MAIN Not Found')
end

while task.wait(3) do
    for i, v in Players:GetChildren() do
        if table.find(Config.LIST_CLONE, v.Name) and not table.find(cloneSent, v.Name) then
            local count = 0

            PrintDebug('Detected Clone: ' .. v.Name)
            while count < Config.AMOUNT do
                Player.Character.Humanoid:UnequipTools()
                for _, pet in Player.Backpack:GetChildren() do
                    if count >= Config.AMOUNT then
                        PrintDebug('Enough Amount')
                        table.insert(cloneSent, v.Name)
                        break   
                    end

                    local petUUID = pet:GetAttribute('PET_UUID')
                    if not petUUID then
                        continue
                    end
                    
                    local petAge = PetsData[petUUID].PetData.Level
                    if petAge >= Config.MIN_AGE and petAge <= Config.MAX_AGE then
                        PrintDebug('Found: ' .. pet.Name)

                        if pet:GetAttribute(InventoryEnums['Favorite']) then
                            PrintDebug('Detected Favorited -> UnFavorite...')
                            FavoriteRemote:FireServer(pet)
                        end

                        Player.Character.Humanoid:UnequipTools()
                        pet.Parent = Player.Character
                        task.wait(0.3)
                        PrintDebug('Gifting...')
                        GiftPetRemote:FireServer("GivePet", v)

                        if waitUntilDone(pet) then
                            PrintDebug('Gift Success')
                            count = count + 1
                            task.wait(2)
                        else
                            PrintDebug('Time Expired -> Again...')
                        end
                    end
                end
            end
        end
    end
end
