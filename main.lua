-- Push lets us use virtual resolution to give a more retro aesthetic.
-- https://github.com/Ulydev/push
push = require 'push'

-- Class makes OOP easier in Love2D
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- Paddle class stores position and dimensions for each paddle and rendering logic
require 'Paddle'

-- Ball class stores position, dimensions and rendering logic for ball
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Paddle speed
PADDLE_SPEED = 200

-- love.load runs once, when the game initializes

function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
    -- and graphics; try removing this function to see the difference!
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed random num generator with current time to vary on each startup
    math.randomseed(os.time())

    -- variable for small fonts
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- larger font variable for score
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set active font to smallFont variable
    love.graphics.setFont(smallFont)

    -- Initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- initialize score variables
    player1Score = 0
    player2Score = 0

    -- paddle positions (y for up and down)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    -- game state variable to determine render and update
    gameState = 'start'
end

function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current y scaled by deltaTime
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        -- add paddle speed to current y scaled by deltaTime
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

end

function love.keypressed(key)
    -- key accessed by string name
    if key == 'escape' then
        -- terminate application
        love.event.quit()

        -- pressing enter during start state will switch to play state
        -- during play state, the ball will move in a random direction
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
        end
    end
end

-- love.draw is called after update by love2d, used to draw anything to the screen

function love.draw()
    -- render at virtual resolution
    push:apply('start')

    -- clear screen with specified color
    -- values must be x/255
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Welcome text at top of screen 
    -- If you don't want the scoreFont that is used below to apply here, 
    -- you must set smallFont up here
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', -- test to render
    0, -- Starting x, 0 because we'll center it
    20, -- Starting Y, halfway down the screen
    VIRTUAL_WIDTH, -- number of pixels to center within the entire screen
    'center' -- alignment mode, can be 'center, 'left', or 'right'
    )

    -- draw score on screen
    -- set font before the block you wish to use it in
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- left side paddle
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- right side paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- end rendering with virtual resolution
    push:apply('end')
end
