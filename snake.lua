-- game variables
local GAME_SIZE = 500
local testing = "hell nah"
-- make a mapping for the picture
-- first number is for the x value and second for y 
local bitmap_file = {
    "resources/snake_head.png",
    "resources/snake_tail.png",
    "resources/snake_body.png",
    "resources/apple.png"
}
Tile ={
    tile_size = 64,

    draw = function (self)
        --testing = "you made it here ig"
            draw_bitmap(self.bitmap, self.pos_x, self.pos_y, self.source_x, self.source_y,
            self.source_x + self.tile_size, self.source_y + self.tile_size)
        end,

    update_direction = function (self, dir)
        --if self.bitmap_info == string. "resources/snake_body.png" then
        --if (string.match(self.bitmap_info, "resources/snake_body.png")) then
        if string.find(self.bitmap_info, "resources/snake_body.png") ~= nil then
            if (dir ==1 ) then -- left
                self.source_x = self.tile_size * 5
            elseif (dir ==2 ) then -- down
                self.source_x = self.tile_size * 2
            elseif (dir ==3) then --up
                self.source_x = self.tile_size * 2
            elseif (dir ==4 ) then --right
                self.source_x = self.tile_size * 5
            end
        else
            if (dir ==1 ) then -- left
                self.source_x = 0
            elseif (dir ==2 ) then -- down
                self.source_x = self.tile_size 
            elseif (dir ==3) then --up
                self.source_x = self.tile_size * 2
            elseif (dir ==4 ) then --right
                self.source_x = self.tile_size * 3
            end
        end
        self.direction = dir
    end,

    new = function (self,bitmap_info, direction, pos_x, pos_y)      
        testing = bitmap_info  
        local instance = {
        direction = direction or 1,
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
}

-- Snake class
-- uses segment class as parts 

Snake = {
    -- Attributes
    directions = 1,

    -- Methods
    new = function (self, x,y,direction,segments_num)
        testing = tostring(bitmap_file[1])
        local instance = {
        x = x or 0,
        y = y or 0,
        direction = direction or 1,
        segments = {},
        grow_segments = 0,
        segments_num= segments_num,
        -- add head
        head_tile = Tile:new(tostring(bitmap_file[1]), direction,x,y)
        }
        setmetatable(instance, { __index = Snake })
        --testing = tostring(bitmap_file[1])
        -- add body parts

        -- add tail

        return instance
    end,

    grow = function (self)
        self.grow_segments = self.grow_segments + 1
    end,

    move = function (self)
        
    end,

    draw = function (self)
        draw_string(testing,300,300)
        self.head_tile:draw()
    end,

    init = function (self)
        self.head_tile:update_direction()
    end
}