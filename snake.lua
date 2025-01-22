-- game variables
local GAME_SIZE = 500
local tile_size = 16

Pickup = {
    -- Attributes
    -- Methods
    new = function (self)
        local max_size = math.floor(WINDOW_SIZE/tile_size)
        local instance = {
            pos_x = math.floor(math.random(max_size-1) * tile_size),
            pos_y = math.floor(math.random(max_size-1) * tile_size),
            -- add head
            apple_bitmap = Bitmap.new("resources/apple.png", true),
        }

        setmetatable(instance, { __index = Pickup })

        return instance
    end,

    draw = function (self)
        draw_bitmap(self.apple_bitmap, self.pos_x, self.pos_y)
        end,
}

local bitmap_file = {
    "resources/snake_head.png",
    "resources/snake_tail.png",
    "resources/snake_body.png",
}
Tile ={
    direction_map = {
                -- When moving Right (R)
                [4] = { [2] = 4, [3] = 1 },
                -- When moving Left (L)
                [1] = { [2] = 3, [3] = 0 },
                -- When moving Down (D)
                [2] = { [1] = 1, [4] = 0 },
                -- When moving Up (U)
                [3] = { [1] = 4, [4] = 3 },
                -- When not turning
                [0] = { [1] = 5, [2] = 2, [3] = 2, [4] = 5 },
                -- head and tail
                [5] = { [1] = 0, [2] = 1, [3] = 2, [4] = 3 }
                }, -- my lookup table for the snake pieces

    draw = function (self)
            draw_bitmap(self.bitmap, self.pos_x, self.pos_y, self.source_x, 0,
            self.source_x + tile_size, tile_size)
        end,

    update_direction = function (self, dir, extra_dir)
        -- can be empty
        extra_dir = extra_dir or 0

        dir = math.floor(dir)
        extra_dir = math.floor(extra_dir)
        self.direction = dir

        if string.find(tostring(self.bitmap_info), "resources/snake_body.png") == nil then
            extra_dir = 5 -- not a body
        end

        local source_number = Tile.direction_map[extra_dir][dir]
        self.source_x = tile_size * math.floor(source_number)
        
    end,

    new = function (self,bitmap_info)      
        local instance = {
        direction = 4,
        source_x = 0,
        pos_x = 0,
        pos_y = 0,
        bitmap_info = bitmap_info,
        bitmap = Bitmap.new(tostring(bitmap_info), true)
        }
        setmetatable(instance, { __index = Tile })
        return instance
    end,

    change_pos = function (self, new_x, new_y)
        self.pos_x = math.floor(new_x)
        self.pos_y = math.floor(new_y)
    end
}

-- Snake class
-- uses segment class as parts 

Snake = {
    -- Attributes
    move_interval = 7,
    -- Methods
    new = function (self)
        local instance = {
            move_timer=0,

            -- add head
            head_tile = Tile:new(tostring(bitmap_file[1])),
            -- add tail
            tail_tile = Tile:new(tostring(bitmap_file[2])),

            -- the full snake:
            full_snake = {},
        }

        setmetatable(instance, { __index = Snake })
        return instance
    end,

    move = function (self)

        self.move_timer = self.move_timer + 1

        -- Only move if the timer reaches the move interval
        if self.move_timer > self.move_interval then
            
            -- move each part of the snake starting from the tail
            for i = #self.full_snake, 2, -1 do
                self.full_snake[i].pos_x = self.full_snake[i - 1].pos_x
                self.full_snake[i].pos_y = self.full_snake[i - 1].pos_y
                
                --also update direction
                local current_dir = math.floor(self.full_snake[i].direction)
                local prev_dir = math.floor(self.full_snake[i - 1].direction)

                if current_dir ~= prev_dir then
                    self.full_snake[i]:update_direction(prev_dir, current_dir)
                else
                    self.full_snake[i]:update_direction(prev_dir)
                end

            end

            -- Move the head based on its direction
            local head = self.full_snake[1]
            if head.direction == 1 then -- left
                head.pos_x = head.pos_x - tile_size
            elseif head.direction == 2 then -- down
                head.pos_y = head.pos_y + tile_size
            elseif head.direction == 3 then -- up
                head.pos_y = head.pos_y - tile_size
            elseif head.direction == 4 then -- right
                head.pos_x = head.pos_x + tile_size
            end
            
            -- Reset the timer after moving
            self.move_timer = 0

            -- collision check
            if self:check_self_collision() or self:check_boundary_collision() then
                return true --send back a signal to end the game
            end

        end
        return false
    end,

    change_direction = function (self, new_dir) -- pas down the needed directions
        if self.full_snake[1].direction + new_dir ==5 then return end
        self.full_snake[1]:update_direction(new_dir)
    end,

    draw = function (self)
        for _, snake_part in ipairs(self.full_snake) do
            snake_part:draw()
        end
    end,

    init = function (self)
        local first_dir = 4
        local start_pos = math.floor(math.floor(math.floor(WINDOW_SIZE/tile_size) /2) * tile_size)
        self.head_tile:change_pos(start_pos, start_pos)
        self.tail_tile:change_pos(start_pos- tile_size, start_pos)
        self.head_tile:update_direction(first_dir)
        self.tail_tile:update_direction(first_dir)

        -- make the full snake
        self.full_snake = {self.head_tile, self.tail_tile}

    end,

    add_segment = function (self)
        -- shift the tail when you add new segment
        local old_tail = table.remove(self.full_snake, math.floor(#self.full_snake))
        
        local new_tile = Tile:new(tostring(bitmap_file[3]))
        new_tile:change_pos(old_tail.pos_x,old_tail.pos_y)
        new_tile:update_direction(old_tail.direction)

        table.insert(self.full_snake, new_tile)
        
        if (old_tail.direction ==1 ) then -- left
            old_tail.pos_x = old_tail.pos_x + tile_size
        elseif (old_tail.direction ==2 ) then -- down
            old_tail.pos_y = old_tail.pos_y - tile_size
        elseif (old_tail.direction ==3) then --up
            old_tail.pos_y = old_tail.pos_y + tile_size
        elseif (old_tail.direction ==4 ) then --right
            old_tail.pos_x = old_tail.pos_x - tile_size
        end
        
        table.insert(self.full_snake, old_tail)
    end,

    check_self_collision = function(self)
        local head = self.full_snake[1]
        for i = 2, #self.full_snake do
            local segment = self.full_snake[i]
            if head.pos_x == segment.pos_x and head.pos_y == segment.pos_y then
                return true -- snek hit
            end
        end
        return false 
    end,

    check_boundary_collision = function(self)
        local head = self.full_snake[1]
        if head.pos_x < 0 or head.pos_x+tile_size >= WINDOW_SIZE or
            head.pos_y < 0 or head.pos_y+tile_size >= WINDOW_SIZE then
            return true -- window hit
        end
        return false
    end,

    check_other_collision = function(self, apple)
        local head = self.full_snake[1]        
        if head.pos_x > apple.pos_x-tile_size and head.pos_x <= apple.pos_x and
            head.pos_y > apple.pos_y-tile_size and head.pos_y <= apple.pos_y then
            return true -- apple hit
        end
        return false
    end
}