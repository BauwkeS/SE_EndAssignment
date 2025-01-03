--- @meta
--- This file provides type annotations for Lua scripts interacting with C++ via SOL2.

--- ||||||||||||||||||||||
--- BIND ENGINE FUNCTIONS
--- ||||||||||||||||||||||

--- INIT FUNCTIONS

--- init function of the window
--- @return nil
function initialize() end

--- function to set Window title
---@param title string # title of the window
---@return nil
function set_window_title(title) end

--- function to set the Window size
---@param width int # width of the window
---@param height int # height of the window
---@return nil
function set_window_size(width,height) end

