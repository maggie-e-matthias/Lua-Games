PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
    -- Initializes the pipes before even showing up on screen 
    self.x = VIRTUAL_WIDTH + 32

    -- This is where the top pipe ends
    -- Add a gap value and that's where the bottom one starts
    self.y = y

    -- Initializes two pipes
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Whether the pipe is ready to be removed or not
    self.remove = false

    -- To signal whether the player passed it or not 
    self.scored = false
end

function PipePair:update(dt)
    -- move pipe from right to left 
    -- if beyond left edge of screen, remove it
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x 
        self.pipes['upper'].x = self.x 
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end