-- Global constants
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Game initializor (Runs only one time at the start of the game)
function love.load()
    --applies the nearest-neighbor filtering on upscaling and downscaling to avoid blurring of the text

    love.graphics.setDefaultFilter('nearest', 'nearest')

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

    love.graphics.printf(
        'Hello Pong!',          -- text to render
        0,                      -- starting X (0 since we're going to center it based on width)
        VIRTUAL_HEIGHT/ 2 - 6,  -- starting Y (halfway down the screen)
        VIRTUAL_WIDTH,           -- number of pixels to center within (the entire screen here)
        'center')               -- alignment mode, can be 'center', 'left', or 'right'

    -- finish rendering
    push.finish()
end

-- Handles Keyboard input
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end