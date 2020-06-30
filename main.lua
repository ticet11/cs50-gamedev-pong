-- Copy of pong, built during CS50 Game Dev Course


-- Push lets us use virtual resolution to give a more retro aesthetic.
-- 
-- push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- VIRTUAL_WIDTH = 432
-- VIRTUAL_HEIGHT = 243

-- love.load runs once, when the game initializes
-- https://github.com/Ulydev/push

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- love.draw is called after update by love2d, used to draw anything to the screen

function love.draw()
    love.graphics.printf(
        'Hello Pong!',          -- test to render
        0,                      -- Starting x, 0 because we'll center it
        WINDOW_HEIGHT / 2 - 6,  -- Starting Y, halfway down the screen
        WINDOW_WIDTH,           -- number of pixels to center within the entire screen
        'center'                -- alignment mode, can be 'center, 'left', or 'right'
    )
end
