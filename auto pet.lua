print('Exec')
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer.Backpack

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local DataService = require(ReplicatedStorage.Modules.DataService):GetData()
local PetsData = DataService.PetsData.PetInventory.Data
local GiftPetRemote = ReplicatedStorage.GameEvents.PetGiftingService
local FavoriteRemote = ReplicatedStorage.GameEvents.Favorite_Item
local InventoryEnums = require(ReplicatedStorage.Data.EnumRegistry.InventoryServiceEnums)

getgenv().Config = {
    MAIN = {
        "cosmicVortex_148QBx", "roboV2lrB4y", "digital_Pulsefwz4LWp", "Nano7bE9BRkr", "synthetic_Byte9M",
        "IIdealHorned2", "techGq0hTv08FM", "PhantomCrisp70", "Cosmic_bladezNsclaB", "RivalCrane333",
        "Virtual_Byte61WMgN", "atomicgNRn", "HereCherryHeron", "techjYwned1", "PelicanGo1275",
        "digitalCoregwecwJ1cs", "roboX2M500WDBPz5", "stellar_System55dj", "MicroPowerfulGoose", "quantumpulse0ig"
    },
    LIST_CLONE = {"PrairieUp4607"},
    LIST_PET = {"Phoenix"},
    AMOUNT = 3
}

local Config = getgenv().Config
local cloneSent = {}

function PrintDebug(msg)
    print('[DEBUG] ' .. msg)
end

-- Auto Accept Gift SIÊU NHANH cho CLONE
if table.find(Config.LIST_CLONE, Player.Name) then
    PrintDebug('TURBO MODE - Clone Auto Accept Gift: ' .. Player.Name)
    ReplicatedStorage.GameEvents.GiftPet.OnClientEvent:Connect(function(uuid, petInfo, gifter)
        -- ACCEPT NGAY LẬP TỨC - KHÔNG DELAY
        ReplicatedStorage.GameEvents.AcceptPetGift:FireServer(true, uuid)
        PrintDebug('TURBO Accept from ' .. gifter .. ': ' .. petInfo)
    end)
end

-- Main Loop SIÊU NHANH
while task.wait(0.5) do -- GIẢM TỪ 3s XUỐNG 0.5s
    if table.find(Config.MAIN, Player.Name) then
        for _, clone in Players:GetChildren() do
            if table.find(Config.LIST_CLONE, clone.Name) and not table.find(cloneSent, clone.Name) then
                PrintDebug('TURBO MODE - Clone: ' .. clone.Name)
                
                local giftCount = 0
                
                while giftCount < Config.AMOUNT do
                    Player.Character.Humanoid:UnequipTools()
                    local foundTargetPet = false
                    
                    for _, pet in Player.Backpack:GetChildren() do
                        if giftCount >= Config.AMOUNT then break end
                        
                        local petUUID = pet:GetAttribute('PET_UUID')
                        if petUUID and PetsData[petUUID] then
                            local petType = PetsData[petUUID].PetType
                            
                            if table.find(Config.LIST_PET, petType) then
                                foundTargetPet = true
                                PrintDebug('TURBO Gift: ' .. petType .. ' (' .. (giftCount + 1) .. '/' .. Config.AMOUNT .. ')')
                                
                                -- UNFAVORITE SIÊU NHANH
                                if pet:GetAttribute(InventoryEnums['Favorite']) then
                                    FavoriteRemote:FireServer(pet)
                                    task.wait(0.05) -- GIẢM TỪ 0.5s XUỐNG 0.05s
                                end
                                
                                Player.Character.Humanoid:UnequipTools()
                                pet.Parent = Player.Character
                                task.wait(0.05) -- GIẢM TỪ 0.3s XUỐNG 0.05s
                                GiftPetRemote:FireServer("GivePet", clone)
                                
                                -- KIỂM TRA SIÊU NHANH
                                local timeout = 0
                                while pet.Parent and timeout < 30 do -- GIẢM TỪ 100 XUỐNG 30
                                    timeout = timeout + 1
                                    task.wait(0.03) -- GIẢM TỪ 0.1s XUỐNG 0.03s
                                end
                                
                                if not pet.Parent then
                                    giftCount = giftCount + 1
                                    PrintDebug('TURBO Success! ' .. giftCount .. '/' .. Config.AMOUNT)
                                    task.wait(0.2) -- GIẢM TỪ 2s XUỐNG 0.2s
                                    break
                                else
                                    PrintDebug('TURBO Retry...')
                                end
                            end
                        end
                    end
                    
                    if not foundTargetPet then
                        PrintDebug('TURBO - No pets found - Kicking')
                        Player:Kick('No ' .. table.concat(Config.LIST_PET, '/') .. ' available')
                        return
                    end
                end
                
                PrintDebug('TURBO Complete: ' .. clone.Name .. ' - ' .. giftCount .. ' pets')
                table.insert(cloneSent, clone.Name)
            end
        end
    end
end
