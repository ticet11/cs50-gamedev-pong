-- Push lets us use virtual resolution to give a more retro aesthetic.
-- https://github.com/Ulydev/push
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- love.load runs once, when the game initializes

function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
    -- and graphics; try removing this function to see the difference!
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- 'retro' font
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- set active font to smallFont variable
    love.graphics.setFont(smallFont)

    -- Initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    -- key accessed by string name
    if key == 'escape' then
        -- terminate application
        love.event.quit()
    end
end

-- love.draw is called after update by love2d, used to draw anything to the screen

function love.draw()
    -- render at virtual resolution
    push:apply('start')

    love.graphics.printf('Hello Pong!', -- test to render
    0, -- Starting x, 0 because we'll center it
    VIRTUAL_HEIGHT / 2 - 6, -- Starting Y, halfway down the screen
    VIRTUAL_WIDTH, -- number of pixels to center within the entire screen
    'center' -- alignment mode, can be 'center, 'left', or 'right'
    )

    -- end rendering with virtual resolution
    push:apply('end')
end
