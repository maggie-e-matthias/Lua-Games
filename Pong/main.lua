-- Classess

Class = require 'class'

require 'Paddle'
require 'Ball'

-- [[ Global Variables]]

push = require 'push'

gameState = 'start'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 --speed at which the paddle moves multiplied by dt in update

--ball variables
ballX = VIRTUAL_WIDTH / 2 - 2
ballY = VIRTUAL_HEIGHT / 2 - 2

ballDX = math.random(2) == 1 and 100 or -100
ballDY = math.random(-50, 50)


-- Game initializor (Runs only one time at the start of the game)
function love.load()
    --applies the nearest-neighbor filtering on upscaling and downscaling to avoid blurring of the text

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set a more retro-looking font as the default
    smallfont = love.graphics.newFont('font.ttf', 8)

    love.graphics.setFont(smallfont)

    --sets up the actual window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{
        vsync = true; 
        fullscreen = false; 
        resizable = false; 
    })

    -- Sets up the virtual resolution, which will be renedered within our actual window no matter its actual size
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscaling = 'normal'})
end

-- Called after update to render changes and draw whatever we want

function love.draw()
    -- start rendering
    push.start()

    --clears the screen with a specific color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- print a welcome message to top of the screen
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')               
    
    --render left paddle 
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    --render right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20)

    --render ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/ 2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)



    -- finish rendering
    push.finish()
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

end
-- Handles Keyboard input
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end