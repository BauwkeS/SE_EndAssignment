require("snake")

--- Creates a COLORREF value from RGB components
local function RGB(r, g, b)
    return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16)
end

--- |||||||||||||||||||

local window_size = 700
local end_game = false

local snake = Snake.new(0,math.floor(window_size))

-- end game stuff 
local end_background = Bitmap.new("resources/black_background.png", true)
end_background:set_opacity(50)
local end_font = Font.new("Garamond",true,false,false,36)

-- initialize items like window
function initialize()
    set_window_title("Game 1 - testing snake")
    set_window_size(window_size,window_size)
    snake:init()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
end

-- initialize game items before starting the game
function game_start()
--set player stuff here if you need ad textures etc

end

local function end_game_items()
    end_game = true
    set_font(end_font)
end


function update()
    if(end_game == false) then
        if(is_key_down('W')) then
            snake:change_direction(3)
        end
        if(is_key_down('S')) then
            snake:change_direction(2)
        end
        if(is_key_down('D')) then
            snake:change_direction(4)
        end
        if(is_key_down('A')) then
            snake:change_direction(1)
        end

        if(snake:move()) then
            end_game_items()
        end
    else
        if(is_key_down('Q')) then
            quit()
        end
    end
end

-- add all draw functions needed here
function draw()
    fill_window_rect(RGB(0,0,0)) --fill background first

    set_color(RGB(255,255,255))
    snake:draw()

    if (end_game) then
        draw_bitmap(end_background, 0,0)
        set_color(RGB(255,255,255))
        draw_string("Died!",350-36,350-36)
        draw_string("Press Q to quit",265,380)
    end
end