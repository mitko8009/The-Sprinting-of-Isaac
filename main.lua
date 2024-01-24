Sprint = RegisterMod("Sprint Mod", 1);
local mod = Sprint;
Sprint.MOD_NAME = "Sprint Mod"
Sprint.VERSION = "1.13"
Sprint.AUTHOR = "mitko8009"
Sprint.SOCIAL = "@mitko8009_"


local json = require("json");

mc_stamina_adder = { 0.2, 0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, }
mc_sprint_speed = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, }
mc_max_stamina = { 50, 100, 150, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, }
mc_position = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350, 360, 370, 380, 390, 400, 410, 420}
mc_color = {"white", "blue", "green", "red", "magenta", "cyan", "yellow"}
mc_text_scale = {0.5, 0.75, 1, 1.25, 1.5, 1.75, 2}
mc_sprint_button = {"LEFT CONTROL", "LEFT SHIFT"}
mc_ypos = {195, 206, 217}

--------------
--- Config ---
--------------

settings_SM = {
    -- Base settings
    MAX_STAMINA = mc_max_stamina[2],
    STAMINA_ADDER = mc_stamina_adder[5],
    SPRINT_SPEED = mc_sprint_speed[6],
    
    -- Other Settings
    unlimitedStamina = false, -- Flag for unlimited stamina
    SPRINT_BUTTON = mc_sprint_button[2],
    Quality_Of_Life = true,

    -- HUD Settings
    enableText = true,
    fontalpha = 2.9,
    coords = Vector(0, 0),

    -- Custom Values
    xPos=17
}

-------------------
--- SaveModData ---
-------------------

local function save()
    Isaac.SaveModData(mod, json.encode(settings_SM, "settings"))
end

local function init()
    if Isaac.HasModData(mod) then
        local data = Isaac.LoadModData(mod)
        data = json.decode(data)
        for k,v in pairs(data) do settings_SM[k] = v end
        settings_SM.version = VERSION
    end

    if not Isaac.HasModData(mod) then
        save()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, save)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, save)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, init)

-----------------
--- Main Code ---
-----------------

if ModConfigMenu then
    require("scripts.mcm");
end

local isSpeeded = false;
local stamina = settings_SM.MAX_STAMINA;

local function isSprinting()
    if Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0) and settings_SM.SPRINT_BUTTON == "LEFT SHIFT" then
        return true
    end
    if Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0) and settings_SM.SPRINT_BUTTON == "LEFT CONTROL" then
        return true
    end
end

function mod:postUpdate()
    local player = Isaac.GetPlayer(0);

    if settings_SM.unlimitedStamina then
        stamina = settings_SM.MAX_STAMINA - 3;
    end

    if settings_SM.Quality_Of_Life == true then
        if stamina > settings_SM.MAX_STAMINA then
            stamina = settings_SM.MAX_STAMINA
        end
    end

    ------------------------------ Sprint Speed ------------------------------

    if (isSprinting() and stamina > 0
    and (Input.IsButtonPressed(Keyboard.KEY_W, 0) or Input.IsButtonPressed(Keyboard.KEY_A, 0) or Input.IsButtonPressed(Keyboard.KEY_S, 0) or Input.IsButtonPressed(Keyboard.KEY_D, 0))) then

        stamina = stamina - settings_SM.STAMINA_ADDER;

        if (isSpeeded == false) then -- Speed up
            player.MoveSpeed = player.MoveSpeed + settings_SM.SPRINT_SPEED;
            isSpeeded = true;
        end
    end

    if (isSprinting() and stamina == 0 and isSpeeded == true) then
        player.MoveSpeed = player.MoveSpeed - settings_SM.SPRINT_SPEED;
        isSpeeded = false;
    end

    if (not(isSprinting()) and stamina < settings_SM.MAX_STAMINA) then
        stamina = stamina + settings_SM.STAMINA_ADDER;

        if (isSpeeded == true) then -- Speed down
            player.MoveSpeed = player.MoveSpeed - settings_SM.SPRINT_SPEED;
            isSpeeded = false;
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.postUpdate);

mod.staminaIcon = Sprite();
mod.staminaIcon:Load("gfx/ui/stamina.anm2", true);
mod.staminaIcon:Play("Idle", true);
mod.staminaIcon.Color = Color(1, 1, 1, settings_SM.alpha)

mod.font = Font()
mod.font:Load("font/luaminioutlined.fnt")

function mod:onRender(shaderName)
    local valueOutput = math.ceil((math.floor(stamina) * 100) / settings_SM.MAX_STAMINA)
    if valueOutput == -1 or valueOutput == -2 then valueOutput = 0 end
    valueOutput = valueOutput.."%"

    if settings_SM.enableText and not Game():IsPaused() then
	    mod:updatePosition()
	    local textCoords = settings_SM.coords + Game().ScreenShakeOffset
	    mod.font:DrawString(valueOutput, textCoords.X + 16, textCoords.Y + 1, KColor(1, 1, 1, 0.5), 0, true)
	    mod.staminaIcon:Render(settings_SM.coords, Vector(0, 0), Vector(0, 0))
    end
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)

function mod:updatePosition() -- isaac-planetarium-chance | https://github.com/Sectimus/isaac-planetarium-chance?tab=readme-ov-file
	local TrueCoopShift = false
	local BombShift = false
	local PoopShift = false
	local RedHeartShift = false
	local SoulHeartShift = false
	local DualityShift = false

	local ShiftCount = 0

	settings_SM.coords = Vector(0, 168)

	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()

		if player:GetBabySkin() == -1 then
			if i > 0 and player.Parent == nil and playerType == player:GetMainTwin():GetPlayerType() and not TrueCoopShift then
				TrueCoopShift = true
			end

			if playerType ~= PlayerType.PLAYER_BLUEBABY_B and not BombShift then BombShift = true end
		end
		if playerType == PlayerType.PLAYER_BLUEBABY_B and not PoopShift then PoopShift = true end
		if playerType == PlayerType.PLAYER_BETHANY_B and not RedHeartShift then RedHeartShift = true end
		if playerType == PlayerType.PLAYER_BETHANY and not SoulHeartShift then SoulHeartShift = true end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DUALITY) and not DualityShift then DualityShift = true end
	end

	if BombShift then ShiftCount = ShiftCount + 1 end
	if PoopShift then ShiftCount = ShiftCount + 1 end
	if RedHeartShift then ShiftCount = ShiftCount + 1 end
	if SoulHeartShift then ShiftCount = ShiftCount + 1 end
	ShiftCount = ShiftCount - 1
	if ShiftCount > 0 then settings_SM.coords = settings_SM.coords + Vector(0, (11 * ShiftCount) - 2) end

	if Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_JACOB then
		settings_SM.coords = settings_SM.coords + Vector(0, 30)
	elseif TrueCoopShift then
		settings_SM.coords = settings_SM.coords + Vector(0, 16)
		if DualityShift then
			settings_SM.coords = settings_SM.coords + Vector(0, -2) -- I hate this
		end
	end
	if DualityShift then
		settings_SM.coords = settings_SM.coords + Vector(0, -12)
	end

	if Game().Difficulty == Difficulty.DIFFICULTY_HARD or Game():IsGreedMode() or not CanRunUnlockAchievements() then
		settings_SM.coords = settings_SM.coords + Vector(0, 16)
	end

	settings_SM.coords = settings_SM.coords + (Options.HUDOffset * Vector(20, 12))
end

function mod:onLevelStart()
    stamina = settings_SM.MAX_STAMINA
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onLevelStart)
