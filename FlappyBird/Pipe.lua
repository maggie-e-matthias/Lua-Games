Pipe = Class{}

PIPE_IMAGE = gTextures['pipe']
PIPE_SCROLL = -60 

PIPE_HEIGHT = 430
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT
    self.orientation = orientation
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
    0, 1, self.orientation == 'top' and -1 or 1) 
end