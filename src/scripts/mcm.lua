local function addSpace(tab_name)
    ModConfigMenu.AddSpace(Sprint.MOD_NAME, tab_name)
end

local function getTableIndex(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return i
        end
    end
    return 0
end

ModConfigMenu.UpdateCategory(Sprint.MOD_NAME, {
    Info = "View settings for " .. Sprint.MOD_NAME .. "."
});

ModConfigMenu.AddTitle(Sprint.MOD_NAME, "Info", Sprint.MOD_NAME)
ModConfigMenu.AddText(Sprint.MOD_NAME, "Info", function() return "Sprint.VERSION " .. Sprint.VERSION end);
addSpace("Info")
ModConfigMenu.AddTitle(Sprint.MOD_NAME, "Info", "Developer")
ModConfigMenu.AddText(Sprint.MOD_NAME, "Info", function() return Sprint.AUTHOR end);
ModConfigMenu.AddText(Sprint.MOD_NAME, "Info", function() return "Follow me on Instagram: " .. Sprint.SOCIAL end);

addSpace("Settings")
ModConfigMenu.AddTitle(Sprint.MOD_NAME, "Settings", "Mod Settings")

ModConfigMenu.AddSetting(Sprint.MOD_NAME, "Settings",
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return getTableIndex(mc_max_stamina, settings_SM.MAX_STAMINA)
    end,
    Minimum = 1,
    Maximum = #mc_max_stamina,
    Display = function()
        return "Max Stamina: " .. settings_SM.MAX_STAMINA
    end,
    OnChange = function(n)
        settings_SM.MAX_STAMINA = mc_max_stamina[n]
    end,
});
ModConfigMenu.AddSetting(Sprint.MOD_NAME, "Settings",
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return getTableIndex(mc_sprint_speed, settings_SM.SPRINT_SPEED)
    end,
    Minimum = 1,
    Maximum = #mc_sprint_speed,
    Display = function()
        return "Sprint Speed: " .. settings_SM.SPRINT_SPEED
    end,
    OnChange = function(n)
        settings_SM.SPRINT_SPEED = mc_sprint_speed[n]
    end,
    Info = { 
        "The speed that adds to your base speed when you're sprinting",
    }
});
ModConfigMenu.AddSetting(Sprint.MOD_NAME, "Settings",
{
    Type = ModConfigMenu.OptionType.BOOLEAN,
    CurrentSetting = function()
        return settings_SM.enableText
    end,
    Display = function()
        return "Show Text in HUD: " .. (settings_SM.enableText and "on" or "off")
    end,
    OnChange = function(b)
        settings_SM.enableText = b
    end
});
ModConfigMenu.AddSetting(Sprint.MOD_NAME, "Settings",
{
    Type = ModConfigMenu.OptionType.BOOLEAN,
    CurrentSetting = function()
        return settings_SM.unlimitedStamina
    end,
    Display = function()
        return "Unlimited Stamina: " .. (settings_SM.unlimitedStamina and "on" or "off")
    end,
    OnChange = function(b)
        settings_SM.unlimitedStamina = b
    end,
    Info = {
        "If you turn on this setting your stamina",
        "will always be full",
    }
});
addSpace("Settings")
ModConfigMenu.AddTitle(Sprint.MOD_NAME, "Settings", "Other Settings")
ModConfigMenu.AddSetting(Sprint.MOD_NAME, "Settings",
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return getTableIndex(mc_sprint_button, settings_SM.SPRINT_BUTTON)
    end,
    Minimum = 1,
    Maximum = #mc_sprint_button,
    Display = function()
        return "Sprint Button: " .. settings_SM.SPRINT_BUTTON
    end,
    OnChange = function(n)
        settings_SM.SPRINT_BUTTON = mc_sprint_button[n]
    end
});
ModConfigMenu.AddSetting(Sprint.MOD_NAME, "Settings",
{
    Type = ModConfigMenu.OptionType.BOOLEAN,
    CurrentSetting = function()
        return settings_SM.Quality_Of_Life
    end,
    Display = function()
        return "Quality Of Life Settings: " .. (settings_SM.Quality_Of_Life and "on" or "off")
    end,
    OnChange = function(b)
        settings_SM.Quality_Of_Life = b
    end,
    Info = {
        "It makes the mod more stable.",
        "(It may use more performance)",
    }
});
addSpace("Settings")
ModConfigMenu.AddTitle(Sprint.MOD_NAME, "Settings", "(!) Experimental Settings (!)")
ModConfigMenu.AddSetting(Sprint.MOD_NAME, "Settings",
{
    Type = ModConfigMenu.OptionType.NUMBER,
    CurrentSetting = function()
        return getTableIndex(mc_stamina_adder, settings_SM.STAMINA_ADDER)
    end,
    Minimum = 1,
    Maximum = #mc_stamina_adder,
    Display = function()
        return "Stamina Adder: " .. settings_SM.STAMINA_ADDER
    end,
    OnChange = function(n)
        settings_SM.STAMINA_ADDER = mc_stamina_adder[n]
    end,
    Info = {  
        "(!) This is experimental setting (!)",
        "It's NOT recommended to use",
    }
});
addSpace("Settings")