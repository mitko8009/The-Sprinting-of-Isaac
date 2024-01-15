local MOD_NAME = "Sprint Mod"
local VERSION = "1.9"
local AUTHOR = "mitko8009"
local SOCIAL = "@mitko8009_"

local SprintMod = RegisterMod(MOD_NAME, 1);
local mod = SprintMod;

local json = require("json");

-- Const

local mc_stamina_adder = { 0.2, 0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, }
local mc_sprint_speed = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, }
local mc_max_stamina = { 50, 100, 150, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1500, }
local mc_position = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350, 360, 370, 380, 390, 400, 410, 420}
local mc_position_2 = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250}
local mc_color = {"white", "blue", "green", "red", "magenta", "cyan", "yellow"}
local mc_text_scale = {0.5, 0.75, 1, 1.25, 1.5, 1.75, 2}
local mc_sprint_button = {"LEFT CONTROL", "LEFT SHIFT"}
local mc_ypos = {195, 206, 217}

-----------------------
--- Data & Settings ---
-----------------------

local settings = {
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

---------------------
--- Main Function ---
---------------------

if ModConfigMenu then
    local function addSpace(tab_name)
        ModConfigMenu.AddSpace(MOD_NAME, tab_name)
    end

    local function getTableIndex(tbl, val)
        for i, v in ipairs(tbl) do
            if v == val then
                return i
            end
        end
        return 0
    end

    ModConfigMenu.UpdateCategory(MOD_NAME, {
        Info = "View settings for " .. MOD_NAME .. ".",
    });
    
    ModConfigMenu.AddTitle(MOD_NAME, "Info", MOD_NAME)
    ModConfigMenu.AddText(MOD_NAME, "Info", function() return "Version " .. VERSION end);
    addSpace("Info")
    ModConfigMenu.AddTitle(MOD_NAME, "Info", "Developer")
    ModConfigMenu.AddText(MOD_NAME, "Info", function() return AUTHOR end);
    ModConfigMenu.AddText(MOD_NAME, "Info", function() return "Follow me on Instagram: " .. SOCIAL end);
    
    addSpace("Settings")
    ModConfigMenu.AddTitle(MOD_NAME, "Settings", "Mod Settings")

    ModConfigMenu.AddSetting(MOD_NAME, "Settings",
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return getTableIndex(mc_max_stamina, settings.MAX_STAMINA)
        end,
        Minimum = 1,
        Maximum = #mc_max_stamina,
        Display = function()
            return "Max Stamina: " .. settings.MAX_STAMINA
        end,
        OnChange = function(n)
            settings.MAX_STAMINA = mc_max_stamina[n]
        end,
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Settings",
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return getTableIndex(mc_sprint_speed, settings.SPRINT_SPEED)
        end,
        Minimum = 1,
        Maximum = #mc_sprint_speed,
        Display = function()
            return "Sprint Speed: " .. settings.SPRINT_SPEED
        end,
        OnChange = function(n)
            settings.SPRINT_SPEED = mc_sprint_speed[n]
        end,
        Info = { 
            "The speed that adds to your base speed when you're sprinting",
        }
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Settings",
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return settings.unlimitedStamina
        end,
        Display = function()
            return "Unlimited Stamina: " .. (settings.unlimitedStamina and "on" or "off")
        end,
        OnChange = function(b)
            settings.unlimitedStamina = b
        end,
        Info = {
            "If you turn on this setting your stamina",
            "will always be full",
        }
    });
    addSpace("Settings")
    ModConfigMenu.AddTitle(MOD_NAME, "Settings", "Other Settings")
    ModConfigMenu.AddSetting(MOD_NAME, "Settings",
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return getTableIndex(mc_sprint_button, settings.SPRINT_BUTTON)
        end,
        Minimum = 1,
        Maximum = #mc_sprint_button,
        Display = function()
            return "Sprint Button: " .. settings.SPRINT_BUTTON
        end,
        OnChange = function(n)
            settings.SPRINT_BUTTON = mc_sprint_button[n]
        end
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Settings",
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return settings.Quality_Of_Life
        end,
        Display = function()
            return "Quality Of Life Setting: " .. (settings.Quality_Of_Life and "on" or "off")
        end,
        OnChange = function(b)
            settings.Quality_Of_Life = b
        end,
        Info = {
            "It makes the mod more stable.",
            "(It may use more performance)",
        }
    });
    addSpace("Settings")
    ModConfigMenu.AddTitle(MOD_NAME, "Settings", "(!) Experimental Settings (!)")
    ModConfigMenu.AddSetting(MOD_NAME, "Settings",
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return getTableIndex(mc_stamina_adder, settings.STAMINA_ADDER)
        end,
        Minimum = 1,
        Maximum = #mc_stamina_adder,
        Display = function()
            return "Stamina Adder: " .. settings.STAMINA_ADDER
        end,
        OnChange = function(n)
            settings.STAMINA_ADDER = mc_stamina_adder[n]
        end,
        Info = {  
            "(!) This is experimental setting (!)",
            "It's NOT recommended to use",
        }
    });
    addSpace("Settings")
    ModConfigMenu.AddTitle(MOD_NAME, "Render", "Text Renderer")
    ModConfigMenu.AddSetting(MOD_NAME, "Render",
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return settings.enableText
        end,
        Display = function()
            return "Enable Text: " .. (settings.enableText and "on" or "off")
        end,
        OnChange = function(b)
            settings.enableText = b
        end
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Render",
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return settings.noText
        end,
        Display = function()
            return "No text: " .. (settings.noText and "on" or "off")
        end,
        OnChange = function(b)
            settings.noText = b
        end,
        Info = {
            "It shows only the value of your stamina",
        }
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Render",
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return getTableIndex(mc_ypos, settings.yPos)
        end,
        Minimum = 1,
        Maximum = #mc_ypos,
        Display = function()
            return "Y Pos: " .. settings.yPos
        end,
        OnChange = function(n)
            settings.yPos = mc_ypos[n]
        end,
        Info = { 
            "It changes the Y position of the text"
        }
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Render",
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return settings.percentsStamina
        end,
        Display = function()
            return "Show stamina in percents: " .. (settings.percentsStamina and "on" or "off")
        end,
        OnChange = function(b)
            settings.percentsStamina = b
        end,
        Info = {
            "It shows the stamina in percents %",
        }
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Render",
    {
        Type = ModConfigMenu.OptionType.BOOLEAN,
        CurrentSetting = function()
            return settings.icon
        end,
        Display = function()
            return "Show Icon: " .. (settings.icon and "on" or "off")
        end,
        OnChange = function(b)
            settings.icon = b
        end
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Render",
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return getTableIndex(mc_color, settings.textColor)
        end,
        Minimum = 1,
        Maximum = #mc_color,
        Display = function()
            return "Text Color: " .. settings.textColor
        end,
        OnChange = function(n)
            settings.textColor = mc_color[n]
        end,
        Info = { 
            "Changes the color of the text",
        }
    });
    ModConfigMenu.AddSetting(MOD_NAME, "Render",
    {
        Type = ModConfigMenu.OptionType.NUMBER,
        CurrentSetting = function()
            return getTableIndex(mc_sprint_speed, settings.alpha)
        end,
        Minimum = 1,
        Maximum = #mc_sprint_speed,
        Display = function()
            return "Alpha: " .. settings.alpha
        end,
        OnChange = function(n)
            settings.alpha = mc_sprint_speed[n]
        end,
        Info = { 
            "Transparency of a color (*0.5)"
        }
    });
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
