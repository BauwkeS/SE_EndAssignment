-- game variables
local GAME_SIZE = 500
local testing = "hell nah"
local tile_size = 16
-- make a mapping for the picture
-- first number is for the x value and second for y 
local bitmap_file = {
    "resources/snake_head.png",
    "resources/snake_tail.png",
    "resources/snake_body.png",
    "resources/apple.png"
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
                [3] = { [1] = 4, [4] = 3 }
                }, -- my lookup table for the turns

    draw = function (self)
        --testing = tostring(self.source_x)
            draw_bitmap(self.bitmap, self.pos_x, self.pos_y, self.source_x, self.source_y,
            self.source_x + tile_size, self.source_y + tile_size)
        end,

    update_direction = function (self, dir, extra_dir)
        --if self.bitmap_info == string. "resources/snake_body.png" then
        --if (string.match(self.bitmap_info, "resources/snake_body.png")) then
        --testing = tostring(dir)

        -- can be empty
        extra_dir = extra_dir or 0

        dir = math.floor(dir)
        extra_dir = math.floor(extra_dir)
        self.direction = dir

        if string.find(tostring(self.bitmap_info), "resources/snake_body.png") ~= nil then
            if (extra_dir > 0 ) then -- turns
                local source_number = Tile.direction_map[extra_dir][dir]
                self.source_x = tile_size * math.floor(source_number)
            elseif (dir ==1 or dir ==4) then -- left
                self.source_x = tile_size * 5
            elseif (dir ==2 or dir ==3 ) then -- down
                self.source_x = tile_size * 2
            end
        else
            if (dir ==1 ) then -- left
                self.source_x = 0
            elseif (dir ==2 ) then -- down
                self.source_x = tile_size 
            elseif (dir ==3) then --up
                self.source_x = tile_size * 2
            elseif (dir ==4 ) then --right
                self.source_x = tile_size * 3
            end
        end

        
    end,

    new = function (self,bitmap_info, pos_x, pos_y)      
        local instance = {
        direction = 4,
        source_x = 0,
        source_y = 0,
        pos_x = pos_x or 0,
        pos_y = pos_y or 0,
        bitmap_info = bitmap_info,
        bitmap = Bitmap.new(tostring(bitmap_info), true)
        }
        --testing = "hopefully made a new tile"
        setmetatable(instance, { __index = Tile })
        return instance
    end,

    change_pos = function (self, new_x, new_y)
        self.pos_x = new_x
        self.pos.y = new_y
    end
}

-- Snake class
-- uses segment class as parts 

Snake = {
    -- Attributes
    move_interval = 15,
    -- Methods
    new = function (self, x,y)
        --testing = tostring(bitmap_file[1])
        local instance = {
            move_timer=0,
            segments_num= 2, -- you start with only a tail and head
            -- add head
            head_tile = Tile:new(tostring(bitmap_file[1]),x,y),
            -- add tail
            tail_tile = Tile:new(tostring(bitmap_file[2]),x-tile_size,y),

            -- the full snake:
            full_snake = {}
        }

        setmetatable(instance, { __index = Snake })
        --testing = tostring(bitmap_file[1])

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

                --testing = testing .. tostring(current_dir) .. " & " .. tostring(prev_dir) .. " | "
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

            -- Also update the visuals
            --self.change_direction(self.full_snake[1].direction)

            -- Reset the timer after moving
            self.move_timer = 0
        end
    end,

    change_direction = function (self, new_dir) -- pas down the needed directions
        self.full_snake[1]:update_direction(new_dir)
    end,

    draw = function (self)
        draw_string(testing,300,300)
        for _, snake_part in ipairs(self.full_snake) do
            snake_part:draw()
        end
    end,

    init = function (self)
        --testing = "self.direction: " .. tostring(self.direction)
        local first_dir = 4
        self.head_tile:update_direction(first_dir)
        self.tail_tile:update_direction(first_dir)

        -- make the full snake
        self.full_snake = {self.head_tile, self.tail_tile}

    end,

    add_segment = function (self)
        -- shift the tail when you add new segment
        local old_tail = table.remove(self.full_snake, math.floor(self.segments_num))
        
        local new_tile = Tile:new(tostring(bitmap_file[3]),old_tail.pos_x,old_tail.pos_y)
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
        --testing = tostring(#self.full_snake)
        
        self.segments_num = self.segments_num +1
        --last_x = self.segments[self.segments_num].pos_x
        --last_y = self.segments[self.segments_num].pos_y
    end,
}