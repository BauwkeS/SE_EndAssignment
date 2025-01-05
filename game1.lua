local window_width = 800
local window_height = 500

local playerPosX = 400
local playerPosY = 50
local playerSize = 20

-- initialize items like window
function initialize()
    set_window_title("Game 1 - testing scene")
    set_window_size(window_width,window_height)
end

-- initialize game items before starting the game
function game_start()
--set player stuff here if you need ad textures etc
end

function update()
    if(is_key_down('W')) then
        playerPosY = playerPosY + 10
    end
    if(is_key_down('S')) then
        playerPosY = playerPosY - 10
    end
    if(is_key_down('D')) then
        playerPosX = playerPosX + 10
    end
    if(is_key_down('A')) then
        playerPosX = playerPosX - 10
    end
end

-- add all draw functions needed here
function draw()
    fill_window_rect(0,0,0) --fill background first
    set_color(255,0,0)
    fill_rect(playerPosX,playerPosY,playerPosX+playerSize,playerPosY-playerSize)
end