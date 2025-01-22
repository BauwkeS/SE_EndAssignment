require("snake")

--- Creates a COLORREF value from RGB components
local function RGB(r, g, b)
    return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16)
end

--- |||||||||||||||||||

WINDOW_SIZE = 500

-- game stuff
local snake = Snake.new(0)
local apple_pic = Pickup.new(0)

-- start & end game stuff 
local start_game = true
local end_game = false
local screen_background = Bitmap.new("resources/black_background.png", true)
screen_background:set_opacity(50)
local main_font = Font.new("Garamond",true,false,false,36)
local sub_font = Font.new("Garamond",false,false,false,28)

-- initialize items like window
function initialize()
    set_window_title("- Snek -")
    set_window_size(WINDOW_SIZE,WINDOW_SIZE)
    snake:init()
end

-- initialize game items before starting the game
function game_start()
--set player stuff here if you need ad textures etc

end

local function snake_apple_collision()
    if snake:check_other_collision(apple_pic) == true then
        snake:add_segment()
        apple_pic = Pickup.new(0)
    end
end

local function restart_game(...)
    snake:init()
    end_game = false
end

function update()
    if(end_game == false and start_game == false) then
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
            end_game = true
        end
        snake_apple_collision()
    else
        if(is_key_down('Q')) then
            quit()
        end
        if(is_key_down('P') and start_game == true) then
            start_game = false
        elseif (is_key_down('P') and end_game == true) then
            restart_game()
        end
    end
end

local function draw_start_game()
    if (start_game) then
        local offset = 108
        draw_bitmap(screen_background, 0,0)
        set_color(RGB(255,255,255))
        set_font(main_font)
        draw_string("Welcome to Snek!",math.floor(WINDOW_SIZE/2-offset-20),math.floor(WINDOW_SIZE/2-offset))
        set_font(sub_font)
        draw_string("[use WASD to move]",math.floor(WINDOW_SIZE/2-offset),math.floor(WINDOW_SIZE/6 *5))
        draw_string("Press P to play",math.floor(WINDOW_SIZE/2-offset+30),math.floor(WINDOW_SIZE/2))
    end
end

local function draw_end_game()
    if (end_game) then
        local offset = 36
        draw_bitmap(screen_background, 0,0)
        set_color(RGB(255,255,255))
        set_font(main_font)
        draw_string("Died!",math.floor(WINDOW_SIZE/2-offset),math.floor(WINDOW_SIZE/2-offset))
        set_font(sub_font)
        draw_string("Press Q to quit",math.floor(WINDOW_SIZE/2-offset*2),math.floor(WINDOW_SIZE/2))
        draw_string("Or P to play again",math.floor(WINDOW_SIZE/2-offset*2.5),math.floor(WINDOW_SIZE/2+offset))
    end
end
-- add all draw functions needed here
function draw()
    fill_window_rect(RGB(0,0,0)) --fill background first

    set_color(RGB(255,255,255))
    snake:draw()
    apple_pic:draw()

    draw_start_game()
    draw_end_game()
end