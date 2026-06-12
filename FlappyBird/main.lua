--[[Flappy Bird (remake)]]--

--Classes
push = require 'push'
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

scrolling = true

function love.load()
    math.randomseed(os.time())

    -- Set scaling filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- Set Screen
    love.window.setTitle('Flappy Bird')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = 'normal'})

    -- Set fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)


    love.keyboard.keysPressed = {}

    -- Initialize graphics
    gTextures = {
        ['background'] = love.graphics.newImage('background.png'),
        ['bird'] = love.graphics.newImage('bird.png'), 
        ['ground'] = love.graphics.newImage('ground.png'), 
        ['pipe'] = love.graphics.newImage('pipe.png')
    }
    

    -- Initialize sounds table 
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'), 
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'), 
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'), 
        ['score'] = love.audio.newSource('score.wav', 'static'), 
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- Start music
    sounds['music']:setLooping(true) 
    sounds['music']:play()

    --Initialize state machine 
    gStateMachine = StateMachine {
        ['title'] = function () return TitleScreenState() end, 
        ['play'] = function () return PlayState() end, 
        ['countdown'] = function () return CountdownState() end, 
        ['score'] = function () return ScoreState() end
    }

    --Starts at title screen
    gStateMachine:change('title')

    -- Initialize inputs
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

end

function love.resize(w, h)
    push.resize(w, h)
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push.start()

    love.graphics.draw(gTextures['background'], -backgroundScroll, 0)
    love.graphics.draw(gTextures['ground'], -groundScroll, VIRTUAL_HEIGHT - 16)

    gStateMachine:render()
    
    push.finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end 
end

function love.keyboard.wasPressed(key)
    -- add it to the table of pressed keys in the frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then 
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed()
    return love.mouse.buttonsPressed[button]
end
