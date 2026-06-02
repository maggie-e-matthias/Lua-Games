--[[Pong Remake]] 

-- Classess

Class = require 'class'

require 'Paddle'
require 'Ball'

-- [[ Global Variables]]

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 --speed at which the paddle moves multiplied by dt in update


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

    --Objects Initiailization 
    gameState = 'start' 

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH/ 2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)
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
    player1:render()

    --render right paddle
    player2:render()

    --render ball
    ball:render()

    -- finish rendering
    push.finish()
end

function love.update(dt)
    if gameState == 'serve' then 
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then 
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    end

    -- Detect collision of ball with paddles
    if ball:collides(player1) then
        ball.dx = -ball.dx * 1.03
        ball.x = player1.x + 5
         
        --keeps Y velocity in same direction but randomize it 
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

    if ball:collides(player2) then
        ball.dx = -ball.dx * 1.03
        ball.x = player2.x - 4

        --keeps Y velocity in same direction but randomize it 
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

    --Detect collision of ball with bounds
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end
    
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
    end

    --Score update + winning conditions
    if ball.x < 0 then 
        servingPlayer = 1
        player2Score = player2Score + 1
        
        if player2Score == 10 then 
            winningPlayer = 2
            gameState = 'done'
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    if ball.x > VIRTUAL_WIDTH then 
        servingPlayer = 2
        player1Score = player1Score + 1
        
        if player1Score == 10 then 
            winningPlayer = 1
            gameState = 'done'
        else
            gameState = 'serve'
            ball:reset()
        end
    end

    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end 

    player1:update(dt)
    player2:update(dt)
end

-- Handles Keyboard input
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then 
            gameState = 'play'

        -- Here, the game is basically in a restart state
        elseif gameState == 'done' then 
            gameState = 'serve'

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then 
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end