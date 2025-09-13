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
local PetsData = DataService.PetsData
local GiftPetRemote: RemoteEvent = ReplicatedStorage.GameEvents.PetGiftingService
local FavoriteRemote: RemoteEvent = ReplicatedStorage.GameEvents.Favorite_Item
local UnlockSlotFromPet: RemoteEvent = ReplicatedStorage.GameEvents.UnlockSlotFromPet
local PetsService: RemoteEvent = ReplicatedStorage.GameEvents.PetsService
local InventoryEnums = require(ReplicatedStorage.Data.EnumRegistry.InventoryServiceEnums)

getgenv().Config = {
    MAIN = {"", "", ""},
    LIST_CLONE = {""},
    LIST_PET = {""},
    EQUIP_PETS = {},
    AMOUNT = 3,
    MIN_AGE = 10,
    MAX_AGE = 20,
    EXTRA_PET_SLOT = 8,
    EXTRA_EGG_SLOT = 8
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

function ListPets()
    local listPet = {}
    Player.Character.Humanoid:UnequipTools()
    for i, pet in Player.Backpack:GetChildren() do
        if pet:GetAttribute('PET_UUID') then
            table.insert(listPet, pet)
        end
    end
    return listPet
end

function ListPetEquipped()
    local listPetEquipped = {}
    for i, v in PetsData.EquippedPets do
        table.insert(listPetEquipped, v)
    end
    return listPetEquipped
end

function PetEquippedData()
    local listPet = {}
    for i, v in ListPetEquipped() do
        table.insert(listPet, v)
    end
    return listPet
end

function FindPetEquipped(petName)
    local listPet = {}
    for i, petData in PetEquippedData() do
        if petData.Name == petName then
            table.insert(listPet, petData)
        end
    end
    return listPet
end

function EquipPet(petData)
    PrintDebug('Equip Pet: ' .. petData.PetType .. ' [' .. petData.UUID .. ']')
    PetsService:FireServer("EquipPet", petData.UUID, CFrame.new())
end

function ListSlots()
    local dataSlot = PetsData.MutableStats
    return {
        ["PetEquippedSlots"] = dataSlot.MaxEquippedPets,
        ["EggSlots"] = dataSlot.MaxEggsInFarm,
        ["PurchasedEquipSlots"] = PetsData.PurchasedEquipSlots,
        ["PurchasedEggSlots"] = PetsData.PurchasedEggSlots
    }
end

function AgeCanUpgrade(purchasedCount)
    local listAge = {20, 30, 45, 60, 75}
    return listAge[purchasedCount + 1] or 0
end

function ListPetAge()
    local listPets = {}
    local listUUID = {}

    for uuid, petData in PetsData.PetInventory.Data do
        local petAge = petData.PetData.Level
        listPets[uuid] = petAge
    end

    for uuid, _ in listPets do
        table.insert(listUUID, uuid)
    end

    table.sort(listUUID, function(a, b)
        return listPets[a] < listPets[b]
    end)

    local cache = {}
    for i, v in listUUID do
        table.insert(cache, {UUID = v, AGE = listPets[v]})
    end

    return cache
end

function UpgradeSlot()
    while ListSlots().PurchasedEquipSlots < Config.EXTRA_PET_SLOT do
        local ageUpgrade = AgeCanUpgrade(ListSlots().PurchasedEquipSlots)
        if ageUpgrade ~= 0 then
            PrintDebug('Start Upgrade Extra Pet Slot: ' .. ageUpgrade)

            local listPetAge = ListPetAge()
            local status

            for i, v in listPetAge do
                if v.AGE < ageUpgrade then
                    continue
                end

                PrintDebug(string.format('Found Pet Age: %s [%d]', v.UUID, v.AGE))
                status = true
                UnlockSlotFromPet:FireServer(v.UUID, "Pet")
                break
            end

            if not status then
                PrintDebug('Not Found Pet Age >= ' .. ageUpgrade)
                break
            end
        end
        task.wait(3)
    end

    while ListSlots().PurchasedEggSlots < Config.EXTRA_EGG_SLOT do
        local ageUpgrade = AgeCanUpgrade(ListSlots().PurchasedEggSlots)
        if ageUpgrade ~= 0 then
            PrintDebug('Start Upgrade Extra Egg Slot: ' .. ageUpgrade)

            local listPetAge = ListPetAge()
            local status

            for i, v in listPetAge do
                if v.AGE < ageUpgrade then
                    continue
                end

                PrintDebug(string.format('Found Pet Age: %s [%d]', v.UUID, v.AGE))
                status = true
                UnlockSlotFromPet:FireServer(v.UUID, "Egg")
                break
            end
            
            if not status then
                PrintDebug('Not Found Pet Age >= ' .. ageUpgrade)
                break
            end
        end
        task.wait(3)
    end
end

if not table.find(Config.MAIN, Player.Name) then
    PrintDebug('Active Auto Accept Gift')
    ReplicatedStorage.GameEvents.GiftPet.OnClientEvent:Connect(function(uuid, petInfo, gifter)
        PrintDebug(string.format('Accepting %s From %s...', petInfo, gifter))
        ReplicatedStorage.GameEvents.AcceptPetGift:FireServer(true, uuid)
    end)
end

while task.wait(3) do
    if table.find(Config.MAIN, Player.Name) then
        for i, v in Players:GetChildren() do
            if table.find(Config.LIST_CLONE, v.Name) and not table.find(cloneSent, v.Name) then
                local count = 0

                PrintDebug('Detected Clone: ' .. v.Name)
                local attempts = 0
                while count < Config.AMOUNT and attempts < 10 do
                    attempts = attempts + 1
                    Player.Character.Humanoid:UnequipTools()
                    local foundPet = false
                    local hasPets = false
                    
                    for _, pet in Player.Backpack:GetChildren() do
                        if pet:GetAttribute('PET_UUID') then
                            hasPets = true
                            
                            if count >= Config.AMOUNT then
                                PrintDebug('Enough Amount')
                                table.insert(cloneSent, v.Name)
                                break   
                            end

                            local petUUID = pet:GetAttribute('PET_UUID')
                            if not petUUID then
                                continue
                            end
                            
                            local PetData = PetsData.PetInventory.Data[petUUID]
                            local petName = PetData.PetType
                            local petAge = PetData.PetData.Level

                            if table.find(Config.LIST_PET, petName) or (petAge >= Config.MIN_AGE and petAge <= Config.MAX_AGE) then
                                foundPet = true
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
                                    break
                                else
                                    PrintDebug('Time Expired -> Again...')
                                end
                            end
                        end
                    end
                    
                    if not hasPets or not foundPet then
                        PrintDebug('No suitable pets found - Kicking player')
                        Player:Kick('No suitable pets available for gifting')
                        return
                    end
                end
            end
        end
    else
        UpgradeSlot()

        if not Config.EQUIP_PETS then
            continue
        end

        local count = 0
        for i, v in Config.EQUIP_PETS do
            count = count + 1
        end
        
        if count == 0 then
            continue
        end

        local listPetName = {}
        for petName, petCount in Config.EQUIP_PETS do
            table.insert(listPetName, petName)
        end

        for i, pet in ListPets() do
            if #PetEquippedData() >= ListSlots().PetEquippedSlots then
                break
            end

            local petData = PetsData.PetInventory.Data[pet:GetAttribute('PET_UUID')]

            if not Config.EQUIP_PETS[petData.PetType] then
                continue
            end

            if #FindPetEquipped(petData.PetType) >= Config.EQUIP_PETS[petData.PetType] then
                continue
            end

            EquipPet(petData)
            task.wait(0.5)
        end
    end
end
