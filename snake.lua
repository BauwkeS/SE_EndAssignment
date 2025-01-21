-- game variables
local GAME_SIZE = 500
local testing = "hell nah"
-- make a mapping for the picture
-- first number is for the x value and second for y 

local Tile ={
    source_x = 0,
    source_y = 0,
    type = Bitmap,
    tile_size = 64,

    draw = function (self, pos_x, pos_y)
            draw_bitmap(self.bitmap, pos_x, pos_y, self.source_x, self.source_y,
            self.source_x + self.tile_size, self.source_y + self.tile_size)
        end
}

local TileManager = {
    -- Attributes
    direction_map = {
        head = {
            ["0,-1"] = {3, 0}, -- Up
            ["1,0"] = {4, 0}, -- Right
            ["0,1"] = {4, 1}, -- Down
            ["-1,0"] = {3, 1} -- Left
        },
        tail = {
            ["0,-1"] = {3, 2}, -- Up
            ["1,0"] = {4, 2}, -- Right
            ["0,1"] = {4, 3}, -- Down
            ["-1,0"] = {3, 3} -- Left
        },
        body = {
            ["1,0|-1,0"] = {1, 0}, -- Horizontal
            ["0,1|0,-1"] = {2, 1}, -- Vertical
            ["-1,0|0,1"] = {2, 2}, -- Angle Top-Left
            ["0,-1|-1,0"] = {2, 0}, -- Angle Left-Down
            ["1,0|0,-1"] = {0, 1}, -- Angle Right-Up
            ["0,1|1,0"] = {0, 0}  -- Angle Down-Right
        }
    },
    tile_width = 32, 
    tile_height = 32 ,
    
    -- Methods
    compute_direction_key = function (dx,dy)
        return string.format("%d,%d", dx, dy)
    end,

    compute_body_key = function (dx1,dy1, dx2, dy2)
        return string.format("%d,%d|%d,%d", dx1, dy1, dx2, dy2)
    end,

    -- get tile based on what part it (=context) is and the direction
    get_tile = function (self, context, prev_dx, prev_dy, next_dx, next_dy)
        if context == "head" then
            local key = TileManager:compute_direction_key(next_dx, next_dy)
            return unpack(TileManager.direction_map.head[key] or {3, 0})
        elseif context == "tail" then
            local key = TileManager:compute_direction_key(-prev_dx, -prev_dy)
            return unpack(TileManager.direction_map.tail[key] or {3, 2})
        elseif context == "body" then
            local key = TileManager:compute_body_key(prev_dx, prev_dy, next_dx, next_dy)
            return unpack(TileManager.direction_map.body[key] or {1, 0})
        else -- Standalone
            return 3, 0
        end
    end,

    get_screen_position = function (x,y)
        testing = "hello???"
        --draw_string(testing, 200, 400)
        draw_string(tostring(x), 200, 400)
        local left = x * TileManager.tile_width
        local top = y * TileManager.tile_height
        return left, top
    end,

    get_source_rect = function (tx,ty)
        return {left = tx * 64, top = ty * 64, width = 64, height = 64} -- source png is 64px per one
    end
} 

-- Segment class
-- segments are parts of the snake
local Segment = {
    -- Methods
    update_tile_coords = function (self,prev,next)
        local prev_dx, prev_dy = 0, 0
        local next_dx, next_dy = 0, 0

        if prev then
            prev_dx, prev_dy = self.x - prev.x, self.y - prev.y
        end
        if next then
            next_dx, next_dy = next.x - self.x, next.y - self.y
        end

        self.tx, self.ty = TileManager:get_tile(self.context, prev_dx, prev_dy, next_dx, next_dy)
    end,
    new = function (self,x,y)
        local instance = {
            x = x, -- Logical grid coordinate
            y = y, -- Logical grid coordinate
            tx = 0, -- Tile column for rendering
            ty = 0, -- Tile row for rendering
            context = "standalone" -- Segment context: head, tail, body, standalone
            }
    
            return setmetatable(instance,
            {
                __index = Segment
            })
    end
}

-- Snake class
-- uses segment class as parts 

Snake = {
    -- Attributes
    directions = {
        {0, -1}, -- Up
        {1, 0},  -- Right
        {0, 1},  -- Down
        {-1, 0}  -- Left
    },

    -- Methods
    new = function (x,y,direction,segments_num)
        local instance = {
        x = x or 0,
        y = y or 0,
        direction = direction or 1,
        segments = {},
        grow_segments = 0,
        bitmap = Bitmap.new("resources/snake-graphics.png", true)
        }
        setmetatable(instance, { __index = Snake })

        for i = 1, segments_num or 1 do
            local offset_x = (i - 1) * Snake.directions[direction][1]
            local offset_y = (i - 1) * Snake.directions[direction][2]
            local segment = Segment:new(x - offset_x, y - offset_y)
            segment.context = (i == 1 and "head") or (i == segments_num and "tail") or "body"
            table.insert(instance.segments, segment)
        end

        return instance
    end,

    grow = function (self)
        self.grow_segments = self.grow_segments + 1
    end,

    next_move = function (self)
        local dx, dy = unpack(Snake.directions[self.direction])
        return {x = self.x + dx, y = self.y + dy}
    end,

    move = function (self)
        local next_position = self:next_move()
        self.x, self.y = next_position.x, next_position.y

        local last_segment = self.segments[#self.segments]
        local grow_x, grow_y = last_segment.x, last_segment.y

        for i = #self.segments, 2, -1 do
            self.segments[i].x = self.segments[i - 1].x
            self.segments[i].y = self.segments[i - 1].y
        end

        if self.grow_segments > 0 then
            local new_segment = Segment:new(grow_x, grow_y)
            new_segment.context = "tail"
            self.segments[#self.segments].context = "body"
            table.insert(self.segments, new_segment)
            self.grow_segments = self.grow_segments - 1
        end

        self.segments[1].x, self.segments[1].y = self.x, self.y

        for i, segment in ipairs(self.segments) do
            segment.context = (i == 1 and "head") or (i == #self.segments and "tail") or "body"
            local prev = self.segments[i - 1]
            local next = self.segments[i + 1]
            segment:update_tile_coords(prev, next)
        end
    end,

    draw = function (self)
        for _, segment in ipairs(self.segments) do
            testing = tostring(TileManager)
            local left, top = TileManager:get_screen_position(math.floor(segment.x), segment.y)
            draw_string(testing, 200, 400)
            local source_rect = TileManager:get_source_rect(segment.tx, segment.ty)
            draw_bitmap(self.bitmap, left, top, source_rect[1], source_rect[2],
            source_rect[1] + source_rect[3], source_rect[2] - source_rect[4]) -- `nil` as the texture is handled elsewhere
        end
    end
}