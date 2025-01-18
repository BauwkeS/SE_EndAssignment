
--- Creates a COLORREF value from RGB components
function RGB(r, g, b)
    return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16)
end

--- |||||||||||||||||||

local window_width = 800
local window_height = 500

local playerPosX = 400
local playerPosY = 50
local playerSize = 20

local font1 = Font.new("Freestyle Script",true,false,false,18)
local cat_bitmap = Bitmap.new("resources/cat.png",true)



-- initialize items like window
function initialize()
    set_window_title("Game 1 - testing scene")
    set_window_size(window_width,window_height)
end

-- initialize game items before starting the game
function game_start()
--set player stuff here if you need ad textures etc
---set_font(font1)
end

function update()
    if(is_key_down('W')) then
        playerPosY = playerPosY - 1
    end
    if(is_key_down('S')) then
        playerPosY = playerPosY + 1
    end
    if(is_key_down('D')) then
        playerPosX = playerPosX + 1
    end
    if(is_key_down('A')) then
        playerPosX = playerPosX - 1
    end
end

-- add all draw functions needed here
function draw()
    fill_window_rect(RGB(0,0,0)) --fill background first

    set_color(RGB(0,255,255))
    draw_string("hello there", 100, 200)

    set_color(RGB(255,255,255))
    fill_rect(playerPosX,playerPosY,playerPosX+playerSize,playerPosY-playerSize)
end