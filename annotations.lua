--- @meta
--- This file provides type annotations for Lua scripts interacting with C++ via SOL2.

--- ||||||||||||||||||||||
--- BIND ENGINE FUNCTIONS
--- ||||||||||||||||||||||

--- BASE FUNCTIONS

--- init function
--- @return nil
function initialize() end

--- game start function
--- @return nil
function game_start() end

--- game end function
--- @return nil
function game_end() end

--- update function
--- @return nil
function update() end

--- draw function
--- @return nil
function draw() end

--- GENERAL MEMBER FUNCTIONS

--- function to set Window title
---@param title string # title of the window
---@return nil
function set_window_title(title) end

--- function to set Window position
---@param left int # width of the window
---@param top int # height of the window
---@return nil
function set_window_position(left,top) end

--- function to set the Window size
---@param width int # width of the window
---@param height int # height of the window
---@return nil
function set_window_size(width,height) end

--- function to set the key list
---@param key_list string # string of keylist
---@return nil
function set_key_list(key_list) end

--- function to set the frame rate
---@param frame_rate int # frame rate amount
---@return nil
function set_frame_rate(frame_rate) end

--- function to go to fullscreen
---@return boolean
function go_fullscreen() end

--- function to go to fullscreen
---@return boolean
function go_windowed_mode() end

--- function to set the state of the mouse pointer
---@param value boolean # value to say if the mouse is supposed to be shown or not
---@return nil
function show_mouse_pointer(value) end

--- function to close the window
---@return nil
function quit() end

--- function to get if it's full screen or not
---@return boolean
function is_full_screen() end

--- function to check if a specific key is down
---@param v_key int # key number that wanted down
---@return boolean
function is_key_down(v_key) end

--- function to give a message box with message
---@param message string # the message for the message box
---@return nil
function message_box(message) end


--- ||||||||||||||||||||||
--- BIND DRAW FUNCTIONS
--- ||||||||||||||||||||||

--- function to set the color
---@param r int # red value
---@param g int # green value
---@param b int # blue value
---@return nil
function set_color(r,g,b) end

--- function to set the font
---@param font_name string # name of the font
---@param bold boolean # is it in bold
---@param italic boolean # is it in italic
---@param underline boolean # is it underlined
---@param size int # size of the font
---@return nil
function set_font(font_name,bold,italic,underline,size) end

--- function to set full window to a color
---@param r int # red value
---@param g int # green value
---@param b int # blue value
---@return boolean
function fill_window_rect(r,g,b) end

--- function to draw a line
---@param x1 int # x1
---@param y1 int # y1
---@param x2 int # x2
---@param y2 int # y2
---@return boolean
function draw_line(x1,y1,x2,y2) end

--- function to draw a rect
---@param left int # left rectangle coord
---@param top int # top rect coord
---@param right int # right rect coord
---@param bottom int # bottom rect coord
---@return boolean
function draw_rect(left,top,right,bottom) end

