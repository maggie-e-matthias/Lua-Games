--[[Flappy Bird (remake)]]--

--Classes
Push = require 'push'
Class = require 'class'   
require 'Bird'

-- imported State Machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local backgroundScroll = 0
local groundScroll = 0  

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Flappy Bird')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = 'normal'})

    love.keyboard.keysPressed = {}

    -- Initialize graphics
    local background = love.graphics.newImage('background.png')

    local ground = love.graphics.newImage('ground.png')

    --Initialize state machine 
    gStateMachine = StateMachine {
        ['title'] = function () return TitleScreenState() end, 
        ['play'] = function () return PlayState() end
    }
    --Starts at title screen
    gStateMachine:change('title')


end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    bird:update(dt)

    love.keyboard.keysPressed = {}

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        table.insert(pipes, Pipe())
        print('Added new Pipe!')
        spawnTimer = 0
    end

    --update pipes and have them scroll while on screen
    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        --removes them once off-screen to save memory
        if pipe.x < -pipe.width then
            table.remove(pipes, k)
        end
    end
end

function love.draw()
    push.start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)


    bird:render()
    push.finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end 
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then 
        return true
    else
        return false
    end
end