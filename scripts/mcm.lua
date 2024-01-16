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
        return "Quality Of Life Settings: " .. (settings.Quality_Of_Life and "on" or "off")
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
ModConfigMenu.AddTitle(MOD_NAME, "Render", "Stat Renderer")
ModConfigMenu.AddSetting(MOD_NAME, "Render",
{
    Type = ModConfigMenu.OptionType.BOOLEAN,
    CurrentSetting = function()
        return settings.enableText
    end,
    Display = function()
        return "Enabled: " .. (settings.enableText and "on" or "off")
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
