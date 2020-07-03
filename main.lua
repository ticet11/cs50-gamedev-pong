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

    -- set title for application window
    love.window.setTitle('Pong')

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

    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- place a ball in the middle of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- game state variable to determine render and update
    gameState = 'start'
end

function love.update(dt)
    if gameState == 'play' then
        -- ball collision with paddles -> increase speed in opposite direction
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- randomize y velocity
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- detect upper and lower boundary collision
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        -- account for ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current y scaled by deltaTime
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        -- add paddle speed to current y scaled by deltaTime
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- update ball based on DX and DY if in play state
    -- scale velocity by dt -> framerate-independent
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)

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

            -- ball's reset method
            ball:reset()
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

    -- draw scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- call paddle class render methods
    player1:render()
    player2:render()

    -- render ball
    ball:render()

    -- render FPS
    displayFPS()

    -- end rendering with virtual resolution
    push:apply('end')
end

-- Render FPS
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0 / 255, 255 / 255, 0 / 255, 255 / 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
