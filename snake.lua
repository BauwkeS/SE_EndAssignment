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
    draw = function (self)
        --testing = tostring(self.source_x)
            draw_bitmap(self.bitmap, self.pos_x, self.pos_y, self.source_x, self.source_y,
            self.source_x + tile_size, self.source_y + tile_size)
        end,

    update_direction = function (self, dir)
        --if self.bitmap_info == string. "resources/snake_body.png" then
        --if (string.match(self.bitmap_info, "resources/snake_body.png")) then
        --testing = tostring(dir)
        if string.find(tostring(self.bitmap_info), "resources/snake_body.png") ~= nil then
            if (dir ==1 ) then -- left
                self.source_x = tile_size * 5
            elseif (dir ==2 ) then -- down
                self.source_x = tile_size * 2
            elseif (dir ==3) then --up
                self.source_x = tile_size * 2
            elseif (dir ==4 ) then --right
                self.source_x = tile_size * 5
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

        self.direction = dir
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
    first_dir = 4,
    -- Methods
    new = function (self, x,y)
        --testing = tostring(bitmap_file[1])
        local instance = {
        x = x or 0,
        y = y or 0,
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
        local addition = 1
        --update the head
        if (self.full_snake[1].direction ==1 ) then -- left
            self.head_tile.pos_x = self.head_tile.pos_x - addition
            for _, snake_part in ipairs(self.segments) do
                snake_part.pos_x = snake_part.pos_x - addition
            end
            self.tail_tile.pos_x = self.tail_tile.pos_x - addition

        elseif (self.full_snake[1].direction ==2 ) then -- down
            
            self.head_tile.pos_y = self.head_tile.pos_y + addition
            for _, snake_part in ipairs(self.segments) do
                snake_part.pos_y = snake_part.pos_y + addition
            end
            self.tail_tile.pos_y = self.tail_tile.pos_y + addition

        elseif (self.full_snake[1].direction ==3) then --up
            
            self.head_tile.pos_y = self.head_tile.pos_y - addition
            for _, snake_part in ipairs(self.segments) do
                snake_part.pos_y = snake_part.pos_y - addition
            end
            self.tail_tile.pos_y = self.tail_tile.pos_y - addition

        elseif (self.full_snake[1].direction ==4 ) then --right
            
            -- get the new pos of the head
            for _, snake_part in ipairs(self.full_snake) do
                snake_part.pos_x = snake_part.pos_x + addition
            end
            -- give the old pos to the next one
            
        end
    end,

    change_direction = function (self, new_dir)
        self.full_snake[1].direction = new_dir
    end,

    draw = function (self)
        draw_string(testing,300,300)
        for _, snake_part in ipairs(self.full_snake) do
            snake_part:draw()
        end
    end,

    init = function (self)
        --testing = "self.direction: " .. tostring(self.direction)

        self.head_tile:update_direction(self.first_dir)
        self.tail_tile:update_direction(self.first_dir)

        -- make the full snake
        -- add head
        self.full_snake = {self.head_tile}

        -- add tail
        table.insert(self.full_snake, self.tail_tile)

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
        testing = tostring(#self.full_snake)
        
        self.segments_num = self.segments_num +1
        --last_x = self.segments[self.segments_num].pos_x
        --last_y = self.segments[self.segments_num].pos_y
    end,
}