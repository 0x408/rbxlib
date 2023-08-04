local library = {priorities = {}, friends = {}, notiflist = {ntifs = {}, interval = 12}, settings = {folder_name = "jithack/"..startUpArgs[1];default_accent = Color3.fromRGB(255,255,255)}, drawings = {}, theme = table.clone(themes.Default),currentcolor = nil, flags = {}, open = false, mousestate = services.InputService.MouseIconEnabled, cursor = nil, holder = nil, connections = {}, notifications = {}, gradient = nil};
local drawing  = loadstring(request({Url = 'https://gist.githubusercontent.com/0f76/9dc85c8c380d895373dd306fd372fa59/raw/e2abc40c2b5f159d61b10558c86e4f98823e30f5/drawing_extension.lua', Method = 'GET'}).Body)()
local tween = loadstring(request({Url = 'https://gist.githubusercontent.com/0f76/1661258383c3c320ac5af2c9dd923fd5/raw/ee3c79b95eafa3b732127a0a7d37a4dc43b3bd60/custom_tween.lua', Method = 'GET'}).Body)()
-- // Handler
local handler = {modules = {}}; do
    handler.createModule = function(moduleName, data)
        local module = data or {};
        handler.modules[moduleName] = module;
        return module;
    end;
end;
-- // Utility
local totalunnamedflags = 0;
local utility = handler.createModule("Utility"); do
    function utility.textlength(str, font, fontsize)
        local text = Drawing.new("Text")
        text.Text = str
        text.Font = font
        text.Size = fontsize

        local textbounds = text.TextBounds
        text:Remove()

        return textbounds
    end
end

function library:notify(info)
    local ntif = {instances = {},create_tick = tick()};
    local title = info.text or info.Text or "nil name";
    local time = info.time or info.Time or 5;
    local z = 10;
    --
    local holder = library:create('Square', {
        Position = UDim2.new(0, 19, 0, 75);
        Transparency = 0;
        Thickness = 1;
    }, true)
    --
    local background = library:create('Square', {
        Size = UDim2.new(0, utility.textlength(title, 2, 13).X + 5, 0, 19);
        Position = UDim2.new(0, -500, 0, 0);
        Parent = holder;
        Color = Color3.fromRGB(13,13,13);
        ZIndex = z;
        Thickness = 1;
        Filled = true;
    }, true)
    --
    local outline1 = library:outline(background, Color3.fromRGB(44,44,44), z, true);
    local outline2 = library:outline(outline1, Color3.fromRGB(0,0,0), z, true);
    --
    local line = library:create("Square", {Parent = background, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(0,1,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 11});
    local line1 = library:create("Square", {Parent = background, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(0,1,0,1), Position = UDim2.new(0,0,1,-1), Thickness = 1, Filled = true, ZIndex = 11});

    --
    local notiftext = library:create("Text", {Text = title, Parent = background, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,3,0,2), ZIndex = 11});
    --
	function ntif.update(new_text)
        notiftext.Text = new_text
        background.Size = UDim2.new(0, utility.textlength(new_text, 2, 13).X + 5, 0, 19)
        line1.Size = UDim2.new(0, utility.textlength(new_text, 2, 13).X + 5, 0, 1)
    end

    function ntif.remove()
        local goaway = tween.new(ntif.instances[2], TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,-500,0,0)}):Play()

        task.wait(0.7)

        ntif.instances[1]:Remove()

        table.remove(library.notiflist.ntifs, table.find(library.notiflist.ntifs, ntif))

        library.notiflist.reposition(true)
    end

    task.spawn(function()
        tween.new(line1, TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, utility.textlength(title, 2, 13).X + 5, 0, 1)}):Play()
        task.wait(time)
        ntif.remove()
    end)

    ntif.instances = {holder, background, outline1, outline2, line, notiftext}

    table.insert(library.notiflist.ntifs, ntif)

    function library.notiflist.reposition(isleaving)
        local position_to_go = 60 + 12
        for i, v in pairs(library.notiflist.ntifs) do
            local position = UDim2.new(0,19,0, position_to_go)

            local lerp_table = {Position = position}
            local valuestring = tostring(v.instances[1].Position.X.Offset);

            if tonumber(valuestring) < 0 then
                v.instances[1].Position = position + UDim2.new(0,-4, 0,7)
            end
            if isleaving then
                tween.new(v.instances[1], TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = lerp_table.Position}):Play()
            else
                v.instances[1].Position = lerp_table.Position
                tween.new(v.instances[2], TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
            end
            position_to_go = position_to_go + v.instances[1].Size.Y + 12
        end

    end

    library.notiflist.reposition()
    return ntif  
end;
