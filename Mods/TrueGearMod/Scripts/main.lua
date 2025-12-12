local truegear = require "truegear"

local hookIds = {}
local resetHook = true



function SendMessage(context)
	if context then
		print(context .. "\n")
		return
	end
	print("nil\n")
end

function PlayAngle(event,tmpAngle,tmpVertical)

	local rootObject = truegear.find_effect(event);

	local angle = (tmpAngle - 22.5 > 0) and (tmpAngle - 22.5) or (360 - tmpAngle)
	
    local horCount = math.floor(angle / 45) + 1
	local verCount = (tmpVertical > 0.1) and -4 or (tmpVertical < 0 and 8 or 0)


	for kk, track in pairs(rootObject.tracks) do
        if tostring(track.action_type) == "Shake" then
            for i = 1, #track.index do
                if verCount ~= 0 then
                    track.index[i] = track.index[i] + verCount
                end
                if horCount < 8 then
                    if track.index[i] < 50 then
                        local remainder = track.index[i] % 4
                        if horCount <= remainder then
                            track.index[i] = track.index[i] - horCount
                        elseif horCount <= (remainder + 4) then
                            local num1 = horCount - remainder
                            track.index[i] = track.index[i] - remainder + 99 + num1
                        else
                            track.index[i] = track.index[i] + 2
                        end
                    else
                        local remainder = 3 - (track.index[i] % 4)
                        if horCount <= remainder then
                            track.index[i] = track.index[i] + horCount
                        elseif horCount <= (remainder + 4) then
                            local num1 = horCount - remainder
                            track.index[i] = track.index[i] + remainder - 99 - num1
                        else
                            track.index[i] = track.index[i] - 2
                        end
                    end
                end
            end
            if track.index then
                local filteredIndex = {}
                for _, v in pairs(track.index) do
                    if not (v < 0 or (v > 19 and v < 100) or v > 119) then
                        table.insert(filteredIndex, v)
                    end
                end
                track.index = filteredIndex
            end
        elseif tostring(track.action_type) ==  "Electrical" then
            for i = 1, #track.index do
                if horCount <= 4 then
                    track.index[i] = 0
                else
                    track.index[i] = 100
                end
            end
            if horCount == 1 or horCount == 8 or horCount == 4 or horCount == 5 then
                track.index = {0, 100}
            end
        end
    end

	truegear.play_effect_by_content(rootObject)
end

function RegisterHooks()


	for k,v in pairs(hookIds) do
		UnregisterHook(k, v.id1, v.id2)
	end
		
	hookIds = {}



	local funcName = "/Game/VR_OR_NOT/Assets/BP_MotionController.BP_MotionController_C:Grab"
	local hook1, hook2 = RegisterHook(funcName, Grab)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Game/VR_OR_NOT/Assets/BP_MotionController.BP_MotionController_C:UnGrab"
	local hook1, hook2 = RegisterHook(funcName, UnGrab)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Game/VR_OR_NOT/Assets/BP_MotionController.BP_MotionController_C:GrabHolster"
	local hook1, hook2 = RegisterHook(funcName, GrabHolster)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Game/VR_OR_NOT/Assets/BP_MotionController.BP_MotionController_C:Mag Attach"
	local hook1, hook2 = RegisterHook(funcName, MagAttach)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Game/VR_OR_NOT/Assets/BP_MotionController.BP_MotionController_C:VRMelee"
	local hook1, hook2 = RegisterHook(funcName, VRMelee)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Script/ReadyOrNot.BaseMagazineWeapon:Multicast_OnFire"
	local hook1, hook2 = RegisterHook(funcName, Multicast_OnFire)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

	local funcName = "/Game/VR_OR_NOT/Assets/BP_MotionController.BP_MotionController_C:GrabWorldItem"
	local hook1, hook2 = RegisterHook(funcName, GrabWorldItem)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
    


	local funcName = "/Script/ReadyOrNot.PlayerCharacter:Client_OnPlayerDamage"
	local hook1, hook2 = RegisterHook(funcName, Client_OnPlayerDamage)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    
	-- local funcName = "/Script/ReadyOrNot.PlayerCharacter:Client_OnTakenDamageDetail"
	-- local hook1, hook2 = RegisterHook(funcName, Client_OnTakenDamageDetail)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    
	local funcName = "/Game/VR_OR_NOT/Assets/BP_VRHolster.BP_VRHolster_C:AttachActorToHolster"
	local hook1, hook2 = RegisterHook(funcName, AttachActorToHolster)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }    
    
	local funcName = "/Script/ReadyOrNot.InteractableComponent:OnInteract"
	local hook1, hook2 = RegisterHook(funcName, OnInteract)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Game/VR_OR_NOT/Assets/Grenades/Stinger_Separate/VRON_Stinger_Prefab.VRON_Stinger_Prefab_C:ManageRingRail"
	local hook1, hook2 = RegisterHook(funcName, ManageRingRail)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Game/VR_OR_NOT/Assets/Grenades/CSGas_Separate/VRON_CSGas_Prefab.VRON_CSGas_Prefab_C:ManageRingRail"
	local hook1, hook2 = RegisterHook(funcName, ManageRingRail)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Game/VR_OR_NOT/Assets/Grenades/FlashBang_Separate/VRON_Flash_Prefab.VRON_Flash_Prefab_C:ManageRingRail"
	local hook1, hook2 = RegisterHook(funcName, ManageRingRail)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }


    
    
	-- local funcName = "/Script/ReadyOrNot.PlayerCharacter:Server_FinishHealing"
	-- local hook1, hook2 = RegisterHook(funcName, Server_FinishHealing)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	local funcName = "/Script/ReadyOrNot.PlayerCharacter:Server_PrepareForHeal"
	local hook1, hook2 = RegisterHook(funcName, Server_PrepareForHeal)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
	-- local funcName = "/Script/ReadyOrNot.CharacterHealthComponent:IncreaseReviveHealth"
	-- local hook1, hook2 = RegisterHook(funcName, IncreaseReviveHealth)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }



    
	-- local funcName = "/Script/UMG.WidgetInteractionComponent:IsOverInteractableWidget"
	-- local hook1, hook2 = RegisterHook(funcName, IsOverInteractableWidget)
	-- hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    

    
	local funcName = "/Script/ReadyOrNot.InteractableComponent:GetDistanceFromPlayer"
	local hook1, hook2 = RegisterHook(funcName, GetDistanceFromPlayer)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    

    
    



    
end


-- *******************************************************************
local progress = 0
local progressTime = 0
local animIconName = nil

function GetDistanceFromPlayer(self)
    if self:get().CurrentProgress == 0 then
        return
    end
    if progress == self:get().CurrentProgress then
        return
    end
    progress = self:get().CurrentProgress
    SendMessage("--------------------------------")
	SendMessage("GetDistanceFromPlayer")   
    truegear.play_effect_by_uuid("PlayerInteracting")
    if progress > 0.88 then        
        if animIconName == "Carry Arrested" then
            SendMessage("CarryArrested") 
            truegear.play_effect_by_uuid("CarryArrested")
        end
        animIconName = nil
    end    
    
    SendMessage(self:get().AnimatedIconName:ToString())
    SendMessage(tostring(self:get().CurrentProgress))
    SendMessage(self:get():GetFullName())
end

function IsOverInteractableWidget(self)
    SendMessage("--------------------------------")
	SendMessage("IsOverInteractableWidget") 
    SendMessage(self:get():GetFullName())
end

function IncreaseReviveHealth(self)
    SendMessage("--------------------------------")
	SendMessage("IncreaseReviveHealth")   
    SendMessage(self:get():GetFullName())
end

function Server_PrepareForHeal(self)
    SendMessage("--------------------------------")
	SendMessage("Healing")   
    truegear.play_effect_by_uuid("Healing") 
    SendMessage(self:get():GetFullName())
end

function Server_FinishHealing(self)
    SendMessage("--------------------------------")
	SendMessage("Server_FinishHealing")   
    SendMessage(self:get():GetFullName())
end

local lastGrenadeRingOut = false

function ManageRingRail(self)
    if not lastGrenadeRingOut and self:get().RingOut then
	    SendMessage("--------------------------------")
	    SendMessage("ManageRingRail")   
        truegear.play_effect_by_uuid("PlayerInteract") 
        SendMessage(tostring(self:get().RingOut))
        SendMessage(self:get():GetFullName())
    end
    lastGrenadeRingOut = self:get().RingOut
end

local leftHandItemName = nil
local rightHandItemName = nil
local isTwoHand = false

function CheckSlot(input,slotIndex)
    if input then
        if slotIndex == 0 then
            SendMessage("RightBackSlotInputItem")
            truegear.play_effect_by_uuid("RightBackSlotInputItem") 
        elseif slotIndex == 1 or slotIndex == 18 then
            SendMessage("RightHipSlotInputItem")
            truegear.play_effect_by_uuid("RightHipSlotInputItem") 
        elseif slotIndex == 3 or slotIndex == 17 then
            SendMessage("LeftHipSlotInputItem")
            truegear.play_effect_by_uuid("LeftHipSlotInputItem") 
        elseif slotIndex == 4 then
            SendMessage("LeftBackSlotInputItem")
            truegear.play_effect_by_uuid("LeftBackSlotInputItem") 
        elseif slotIndex == 5 or slotIndex == 6 then
            SendMessage("LeftBellySlotInputItem")
            truegear.play_effect_by_uuid("LeftBellySlotInputItem") 
        elseif slotIndex == 7 or slotIndex == 8 then
            SendMessage("BellySlotInputItem")
            truegear.play_effect_by_uuid("BellySlotInputItem") 
        elseif slotIndex == 9 or slotIndex == 10 or slotIndex == 11 then
            SendMessage("RightBellySlotInputItem")
            truegear.play_effect_by_uuid("RightBellySlotInputItem") 
        elseif slotIndex == 15 or slotIndex == 26 or slotIndex == 27 then
            SendMessage("RightChestSlotInputItem")
            truegear.play_effect_by_uuid("RightChestSlotInputItem") 
        end
    else
        if slotIndex == 0 then
            SendMessage("RightBackSlotOutputItem")
            truegear.play_effect_by_uuid("RightBackSlotOutputItem") 
        elseif slotIndex == 1 or slotIndex == 18 then
            SendMessage("RightHipSlotOutputItem")
            truegear.play_effect_by_uuid("RightHipSlotOutputItem") 
        elseif slotIndex == 3 or slotIndex == 17 then
            SendMessage("LeftHipSlotOutputItem")
            truegear.play_effect_by_uuid("LeftHipSlotOutputItem") 
        elseif slotIndex == 4 then
            SendMessage("LeftBackSlotOutputItem")
            truegear.play_effect_by_uuid("LeftBackSlotOutputItem") 
        elseif slotIndex == 5 or slotIndex == 6 then
            SendMessage("LeftBellySlotOutputItem")
            truegear.play_effect_by_uuid("LeftBellySlotOutputItem") 
        elseif slotIndex == 7 or slotIndex == 8 then
            SendMessage("BellySlotOutputItem")
            truegear.play_effect_by_uuid("BellySlotOutputItem") 
        elseif slotIndex == 9 or slotIndex == 10 or slotIndex == 11 then
            SendMessage("RightBellySlotOutputItem")
            truegear.play_effect_by_uuid("RightBellySlotOutputItem") 
        elseif slotIndex == 15 or slotIndex == 26 or slotIndex == 27 then
            SendMessage("RightChestSlotOutputItem")
            truegear.play_effect_by_uuid("RightChestSlotOutputItem") 
        end
    end
end

function OnInteract(self,InteractInstigator)
	SendMessage("--------------------------------")
	SendMessage("PlayerInteract")
    truegear.play_effect_by_uuid("PlayerInteract")     
    animIconName = self:get().AnimatedIconName:ToString()
    SendMessage(self:get().AnimatedIconName:ToString())
    SendMessage(InteractInstigator:get():GetFullName())
    SendMessage(self:get():GetFullName())
end

function AttachActorToHolster(self)
	SendMessage("--------------------------------")
	SendMessage("AttachActorToHolster")
    CheckSlot(true,self:get().VRItemIndex)
    SendMessage(tostring(self:get().VRItemIndex))
    SendMessage(self:get():GetFullName())
end


local playerDamageCount = 0
local gasTime = 0
local bleedTime = 0
function Client_OnPlayerDamage(self,bTakenDamage,InDamage,InstigatorCharacter,DamageCauser)
    if self:get():GetCurrentHealth() - InDamage:get() <= 0 then
        SendMessage("--------------------------------")
	    SendMessage("PlayerDeath")
        truegear.play_effect_by_uuid("PlayerDeath")
    end
	-- SendMessage("--------------------------------")
	-- SendMessage("Client_OnPlayerDamage")
    -- SendMessage(tostring(self:get().CharacterHealth.HealthStatus)) 
    -- SendMessage(tostring(self:get():GetCurrentHealth())) 
    -- SendMessage(tostring(InDamage:get()))
    local enemy = InstigatorCharacter:get():GetPropertyValue('Controller')
	if enemy:IsValid() == false then 
		-- SendMessage("PlayerSelfDamage2")
        if string.find(DamageCauser:get():GetFullName(),"Stinger") then
            SendMessage("ExplosionDamage")
            truegear.play_effect_by_uuid("ExplosionDamage")
        elseif string.find(DamageCauser:get():GetFullName(),"Flashbang") then
            SendMessage("FlashbangDamage")
            truegear.play_effect_by_uuid("FlashbangDamage")
        elseif string.find(DamageCauser:get():GetFullName(),"CSGas") then
            if os.clock() - gasTime < 0.3 then
                return
            end
            gasTime = os.clock()
            SendMessage("GasDamage")
            truegear.play_effect_by_uuid("GasDamage")
        else
            if InDamage:get() < 2 then
                if os.clock() - bleedTime < 0.3 then
                return
            end
            bleedTime = os.clock()
                SendMessage("Bleeding")
                truegear.play_effect_by_uuid("Bleeding")
            else
                SendMessage("NoDirectionDamage")
                truegear.play_effect_by_uuid("NoDirectionDamage")
            end            
        end
        SendMessage(tostring(InDamage:get()))
		SendMessage(InstigatorCharacter:get():GetFullName())
		SendMessage(DamageCauser:get():GetFullName())
		SendMessage(self:get():GetFullName())
		SendMessage("enemy is not found")
		return
	end
	local enemyRotation = enemy:GetPropertyValue('ControlRotation')
	if enemyRotation:IsValid() == false then 
		SendMessage("enemyRotation is not found")
		return
	end
	
	local playerController = self:get():GetPropertyValue('Controller')
	if playerController:IsValid() == false then 
		SendMessage("playerController is not found")
		return
	end
	local playerRotation = playerController:GetPropertyValue('ControlRotation')
	if playerRotation:IsValid() == false then 
		SendMessage("playerRotation is not found")
		return
	else
		local angleYaw = playerRotation.Yaw - enemyRotation.Yaw
		angleYaw = angleYaw + 180
		if angleYaw > 360 then 
			angleYaw = angleYaw - 360
		end
		SendMessage("DefaultDamage," .. angleYaw .. ",0")
        PlayAngle("DefaultDamage",angleYaw,0)
		SendMessage(tostring(playerRotation.Yaw))
		SendMessage(tostring(enemyRotation.Yaw))
		SendMessage(InstigatorCharacter:get():GetFullName())
		SendMessage(self:get():GetFullName())
	end
end

-- function Client_OnTakenDamageDetail(self,bWasHeadshot,bTorsoShot,bLeftArm,bLeftLeg,bRightArm,bRightLeg,DamageTaken,RemainingHealth)
-- 	SendMessage("--------------------------------")
-- 	SendMessage("Client_OnTakenDamageDetail")
--     if RemainingHealth:get() <= 1 then
--         SendMessage("PlayerDeath")
--         truegear.play_effect_by_uuid("PlayerDeath")
--     end
--     SendMessage(tostring(RemainingHealth:get()))
--     SendMessage(self:get():GetFullName())
-- end

function GrabWorldItem(self,TryGrabBolt,MagFromGun,Success,SkipPostSets)
    if not Success:get() then
        return
    end
	SendMessage("--------------------------------")
	SendMessage("GrabWorldItem")    
    if self:get().Hand == 0 and rightHandItemName ~= nil then
        isTwoHand = true
    elseif self:get().Hand == 1 and leftHandItemName ~= nil then
        isTwoHand = true
    end
    SendMessage(tostring(self:get().Hand))
    SendMessage(tostring(Success:get()))
    SendMessage(self:get():GetFullName())
end

function Multicast_OnFire(self)
    if leftHandItemName == self:get():GetFullName() then
        if self:get():GetCurrentMagazine().AmmoType == 1 then
            SendMessage("--------------------------------")
            SendMessage("LeftHandRifleShoot") 
            truegear.play_effect_by_uuid("LeftHandRifleShoot")
            if isTwoHand then
                SendMessage("RightHandRifleShoot") 
                truegear.play_effect_by_uuid("RightHandRifleShoot")
            end    
        elseif self:get():GetCurrentMagazine().AmmoType == 2 then
            SendMessage("--------------------------------")
            SendMessage("LeftHandSMGShoot") 
            truegear.play_effect_by_uuid("LeftHandSMGShoot")
            if isTwoHand then
                SendMessage("RightHandSMGShoot") 
                truegear.play_effect_by_uuid("RightHandSMGShoot")
            end  
        elseif self:get():GetCurrentMagazine().AmmoType == 4 or self:get():GetCurrentMagazine().AmmoType == 5 or self:get():GetCurrentMagazine().AmmoType == 9 then
            SendMessage("--------------------------------")
            SendMessage("LeftHandShotgunShoot") 
            truegear.play_effect_by_uuid("LeftHandShotgunShoot")
            if isTwoHand then
                SendMessage("RightHandShotgunShoot") 
                truegear.play_effect_by_uuid("RightHandShotgunShoot")
            end  
        else
            SendMessage("--------------------------------")
            SendMessage("LeftHandPistolShoot") 
            truegear.play_effect_by_uuid("LeftHandPistolShoot")
            if isTwoHand then
                SendMessage("RightHandPistolShoot") 
                truegear.play_effect_by_uuid("RightHandPistolShoot")
            end
        end           
    elseif rightHandItemName == self:get():GetFullName() then
        if self:get():GetCurrentMagazine().AmmoType == 1 then
            SendMessage("--------------------------------")
            SendMessage("RightHandRifleShoot") 
            truegear.play_effect_by_uuid("RightHandRifleShoot")
            if isTwoHand then
                SendMessage("LeftHandRifleShoot") 
                truegear.play_effect_by_uuid("LeftHandRifleShoot")
            end    
        elseif self:get():GetCurrentMagazine().AmmoType == 2 then
            SendMessage("--------------------------------")
            SendMessage("RightHandSMGShoot") 
            truegear.play_effect_by_uuid("RightHandSMGShoot")
            if isTwoHand then
                SendMessage("LeftHandSMGShoot") 
                truegear.play_effect_by_uuid("LeftHandSMGShoot")
            end  
        elseif self:get():GetCurrentMagazine().AmmoType == 4 or self:get():GetCurrentMagazine().AmmoType == 5 or self:get():GetCurrentMagazine().AmmoType == 9 then
            SendMessage("--------------------------------")
            SendMessage("RightHandShotgunShoot") 
            truegear.play_effect_by_uuid("RightHandShotgunShoot")
            if isTwoHand then
                SendMessage("LeftHandShotgunShoot") 
                truegear.play_effect_by_uuid("LeftHandShotgunShoot")
            end  
        else
            SendMessage("--------------------------------")
            SendMessage("RightHandPistolShoot") 
            truegear.play_effect_by_uuid("RightHandPistolShoot")
            if isTwoHand then
                SendMessage("LeftHandPistolShoot") 
                truegear.play_effect_by_uuid("LeftHandPistolShoot")
            end
        end
    end
	-- SendMessage("--------------------------------")
	-- SendMessage("Multicast_OnFire")    
    -- SendMessage(self:get():GetFullName())
    -- SendMessage(tostring(self:get():GetCurrentMagazine().AmmoType))
end

local meleeTime = 0

function VRMelee(self,Hit,Actor,Speed)
    if Speed:get() < 0.1 then
        return
    end
    if os.clock() - meleeTime < 0.2 then
        return
    end
    meleeTime = os.clock()
	SendMessage("--------------------------------")
	SendMessage("VRMelee")
    if self:get().Hand == 0 then
        SendMessage("LeftHandMeleeHit")
        truegear.play_effect_by_uuid("LeftHandMeleeHit")
    elseif self:get().Hand == 1 then
        SendMessage("RightHandMeleeHit")
        truegear.play_effect_by_uuid("RightHandMeleeHit")
    end
    SendMessage(tostring(self:get().Hand))
    SendMessage(tostring(Speed:get()))
    SendMessage(tostring(Hit:get().bBlockingHit))
    SendMessage(Actor:get():GetFullName())
    SendMessage(self:get():GetFullName())
end

function MagAttach(self,Attach,Actor,Eject,RC)
	SendMessage("--------------------------------")
	SendMessage("Mag Attach")
    if Attach:get() then
        if self:get().Hand == 0 then
            SendMessage("RightHandMagazineInserted")
        truegear.play_effect_by_uuid("RightHandMagazineInserted")
        else
            SendMessage("LeftHandMagazineInserted")
        truegear.play_effect_by_uuid("LeftHandMagazineInserted")
        end
    end
    if Eject:get() then
        if self:get().Hand == 0 then
            SendMessage("LeftHandMagazineEjected")
        truegear.play_effect_by_uuid("LeftHandMagazineEjected")
        else
            SendMessage("RightHandMagazineEjected")
        truegear.play_effect_by_uuid("RightHandMagazineEjected")
        end
    end
    SendMessage(tostring(self:get().Hand))
    SendMessage(tostring(Attach:get()))
    SendMessage(tostring(Eject:get()))
    SendMessage(Actor:get():GetFullName())
    SendMessage(RC:get():GetFullName())
    SendMessage(self:get():GetFullName())
end

local grabHolsterTime = 0
local grabHolsterIndex = 0
function GrabHolster(self,Holster,NewParam)
	SendMessage("--------------------------------")
	SendMessage("GrabHolster")
    grabHolsterTime = os.clock()
    grabHolsterIndex = Holster:get().VRItemIndex
    -- CheckSlot(false,Holster:get().VRItemIndex)
    SendMessage(tostring(NewParam:get()))
    SendMessage(tostring(Holster:get().ItemFound))
    SendMessage(tostring(Holster:get().VRItemIndex))
    SendMessage(Holster:get():GetFullName())
    SendMessage(self:get():GetFullName())
end


function UnGrab(self)
	SendMessage("--------------------------------")
	SendMessage("UnGrab")
    isTwoHand = false
    if self:get().Hand == 0 then
        SendMessage("LeftHandRelease")
        leftHandItemName = nil
    elseif self:get().Hand == 1 then
        SendMessage("RightHandRelease")
        rightHandItemName = nil
    end
    SendMessage(tostring(self:get().Hand))
    SendMessage(self:get():GetFullName())
end

function Grab(self)
    if not self:get().GrabbedActor:IsValid() then
        return
    end
	SendMessage("--------------------------------")
	SendMessage("Grab")
    if os.clock() - grabHolsterTime < 0.1 then
        CheckSlot(false,grabHolsterIndex)
    end
    if self:get().Hand == 0 then
        SendMessage("LeftHandGrabItem")
        truegear.play_effect_by_uuid("LeftHandGrabItem")
        leftHandItemName = self:get().GrabbedActor:GetFullName()
    elseif self:get().Hand == 1 then 
        SendMessage("RightHandGrabItem")
        truegear.play_effect_by_uuid("RightHandGrabItem")
        rightHandItemName = self:get().GrabbedActor:GetFullName()
    end
    if string.find(self:get().GrabbedActor:GetFullName(),"Chemlight") then
        SendMessage("RightWristSlotOutputItem")
        truegear.play_effect_by_uuid("RightWristSlotOutputItem")
    end
    SendMessage(tostring(self:get().Hand))
    SendMessage(tostring(self:get().GrabbedActor:IsValid()))
    SendMessage(self:get().GrabbedActor:GetFullName())
    -- SendMessage(self:get():GetPropertyValue("Currently Overlapping Actor"):GetFullName())
    SendMessage(tostring(self:get().HeldObject))
    SendMessage(self:get():GetFullName())
end


truegear.seek_by_uuid("DefaultDamage")
truegear.init("1144200", "Ready Or Not")


function CheckPlayerSpawned()
	RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
		if resetHook then
			local ran, errorMsg = pcall(RegisterHooks)
			if ran then
				SendMessage("--------------------------------")
				SendMessage("HeartBeat")
				-- truegear.play_effect_by_uuid("HeartBeat")
				resetHook = false
			else
				print(errorMsg)
			end
		end		
	end)
end

-- function CheckPlayerSpawned()
-- 	RegisterHooks()
-- end

SendMessage("TrueGear Mod is Loaded");
CheckPlayerSpawned()

-- LoopAsync(1000, HeartBeat)
-- LoopAsync(300, GrabbedByAttacker)