MOD_NAME = "Sprint Mod"
VERSION = "1.11"
AUTHOR = "mitko8009"
SOCIAL = "@mitko8009_"

local SprintMod = RegisterMod(MOD_NAME, 1);
local mod = SprintMod;

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

settings = {
    -- Base settings
    MAX_STAMINA = mc_max_stamina[2],
    STAMINA_ADDER = mc_stamina_adder[5],
    SPRINT_SPEED = mc_sprint_speed[6],
    
    -- Other Settings
    unlimitedStamina = false, -- Flag for unlimited stamina
    SPRINT_BUTTON = mc_sprint_button[2],
    Quality_Of_Life = true,
        
    -- Render Settings
    enableText = true,
    noText = true,
    percentsStamina = true,
    icon = true,
    textColor = mc_color[1],
    alpha = mc_sprint_speed[5],
    yPos= mc_ypos[1],

    -- Custom Values
    xPos=17
}

-------------------
--- SaveModData ---
-------------------

local function save()
    Isaac.SaveModData(mod, json.encode(settings, "settings"))
end

local function init()
    if Isaac.HasModData(mod) then
        local data = Isaac.LoadModData(mod)
        data = json.decode(data)
        for k,v in pairs(data) do settings[k] = v end
        settings.version = VERSION
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
local stamina = settings.MAX_STAMINA;

local function isSprinting()
    if Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0) and settings.SPRINT_BUTTON == "LEFT SHIFT" then
        return true
    end
    if Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0) and settings.SPRINT_BUTTON == "LEFT CONTROL" then
        return true
    end
end

function mod:postUpdate()
    local player = Isaac.GetPlayer(0);

    if settings.unlimitedStamina then
        stamina = settings.MAX_STAMINA - 3;
    end

    if settings.Quality_Of_Life == true then
        if stamina > settings.MAX_STAMINA then
            stamina = settings.MAX_STAMINA
        end
    end

    ------------------------------ Sprint Speed ------------------------------

    if (isSprinting() and stamina > 0
    and (Input.IsButtonPressed(Keyboard.KEY_W, 0) or Input.IsButtonPressed(Keyboard.KEY_A, 0) or Input.IsButtonPressed(Keyboard.KEY_S, 0) or Input.IsButtonPressed(Keyboard.KEY_D, 0))) then

        stamina = stamina - settings.STAMINA_ADDER;

        if (isSpeeded == false) then -- Speed up
            player.MoveSpeed = player.MoveSpeed + settings.SPRINT_SPEED;
            isSpeeded = true;
        end
    end

    if (isSprinting() and stamina == 0 and isSpeeded == true) then
        player.MoveSpeed = player.MoveSpeed - settings.SPRINT_SPEED;
        isSpeeded = false;
    end

    if (not(isSprinting()) and stamina < settings.MAX_STAMINA) then
        stamina = stamina + settings.STAMINA_ADDER;

        if (isSpeeded == true) then -- Speed down
            player.MoveSpeed = player.MoveSpeed - settings.SPRINT_SPEED;
            isSpeeded = false;
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.postUpdate);

mod.staminaIcon = Sprite();
mod.staminaIcon:Load("gfx/ui/stamina.anm2", true);
mod.staminaIcon:Play("Idle", true);
mod.staminaIcon.Color = Color(1, 1, 1, settings.alpha)

mod.font = Font()
mod.font:Load("font/luaminioutlined.fnt")

local function onRender(t)
    local text = "";
    text = tostring(math.floor(stamina));

    if text == "-1" or text == "-2" then text = "0" end
    
    if settings.percentsStamina then
        local percents = math.ceil((math.floor(stamina) * 100) / settings.MAX_STAMINA)
        if percents == -1 or percents == -2 then percents = 0 end
        text = tostring(percents).."%"
    end

    if not settings.noText then text = "Stamina: "..text end
    --- Color
    local r = 0;
    local g = 0;
    local b = 0;
    
    if settings.textColor == "white" then r=1; g=1; b=1; end
    if settings.textColor == "red" then r=1; g=0; b=0; end
    if settings.textColor == "green" then r=0; g=1; b=0; end
    if settings.textColor == "blue" then r=0; g=0; b=1; end
    if settings.textColor == "magenta" then r=1; g=0; b=1; end
    if settings.textColor == "cyan" then r=0; g=1; b=1; end
    if settings.textColor == "yellow" then r=1; g=1; b=0; end

    --- Render
    if settings.enableText and not Game():IsPaused() then
        mod.font:DrawString(text, settings.xPos+15, settings.yPos, KColor(r, g, b, settings.alpha), 0, true)
        if settings.icon then
            mod.staminaIcon:Render(Vector(settings.xPos-3, settings.yPos-3), Vector(0,0), Vector(0,0));
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)

function SprintMod:onLevelStart()
    stamina = settings.MAX_STAMINA
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onLevelStart)
