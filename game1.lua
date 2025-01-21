
--- Creates a COLORREF value from RGB components
local function RGB(r, g, b)
    return (r & 0xFF) | ((g & 0xFF) << 8) | ((b & 0xFF) << 16)
end

--- |||||||||||||||||||

local window_size = 500
local help = "nope"
local SnakeBody = {
    -- Attributes

    -- Methods 
    move_body = function (self)
        print("you should move now:D")
    end,

    change_direction = function (self, direction)
        print("aaaaaaaand TURN")
    end,

    set_position = function (self,x, y)
        self.snake_pos_x = x
        self.snake_pos_y = y
    end,

    draw_body = function (self)
        help  = string.format("Drawing rect: left=%d, top=%d, right=%d, bottom=%d",
        self.snake_pos_x,
        self.snake_pos_y,
        self.snake_pos_x + self.snake_size,
        self.snake_pos_y - self.snake_size
    )
        fill_rect(math.floor(self.snake_pos_x),math.floor(self.snake_pos_y),
        math.floor(self.snake_pos_x+self.snake_size),
        math.floor(self.snake_pos_y-self.snake_size))
    end
}





function SnakeBody.new(pos_in_snake)
    local instance = {
        snake_size = 20,
        snake_pos_x = window_size/2, 
        snake_pos_y = window_size / 2,
        position_in_snake = pos_in_snake or 1}

        return setmetatable(instance,
        {
            __index = SnakeBody
        })
end


local snake1 = SnakeBody.new(1)

-- initialize items like window
function initialize()
    set_window_title("Game 1 - testing snake")
    set_window_size(window_size,window_size)
end

-- initialize game items before starting the game
function game_start()
--set player stuff here if you need ad textures etc

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
    draw_string(help, 100, 400)
    set_color(RGB(255,255,255))
    snake1:draw_body()
    
end
