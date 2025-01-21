require("snake")

--- Creates a COLORREF value from RGB components
local function RGB(r, g, b)
    return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16)
end

--- |||||||||||||||||||

local window_size = 700
help = "nope"

local snake = Snake.new(0,math.floor(window_size/2),math.floor(window_size/2))

-- initialize items like window
function initialize()
    set_window_title("Game 1 - testing snake")
    set_window_size(window_size,window_size)
    snake:init()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
    snake:add_segment()
end

-- initialize game items before starting the game
function game_start()
--set player stuff here if you need ad textures etc

end

function update()
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

    snake:move()
end

bitmapTest = Bitmap.new("resources/snake-graphics.png", true)


-- add all draw functions needed here
function draw()
    fill_window_rect(RGB(0,0,0)) --fill background first

    set_color(RGB(0,255,255))
    --draw_string("hello there", 100, 200)
    draw_string(help, 100, 400)
    
    set_color(RGB(255,255,255))
    snake:draw()
    --draw_bitmap(bitmapTest, 100, 100, 0, 0,64, 64) -- `nil` as the texture is handled elsewhere
end
