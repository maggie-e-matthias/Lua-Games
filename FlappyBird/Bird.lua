Bird = Class{}

local Gravity = 20 

function Bird:init()
    --load bird from images on PC
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --Place bird mid-screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    --Apply gravity to bird's velocity 
    self.dy = self.dy + Gravity * dt

    --Add jump if space is pressed
    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end 

    --Apply that velocity to the Y position
    self.y = self.y + self.dy
end

function Bird:collides(pipe)
    -- 2's are left and top offsets
    -- 4's are right and bottom offsets
    -- offsets are given to make players' life easier

    -- x-axis collision 
    if (self.x + 2) + (self.width - 4) >= pipe.x and (self.x + 2) <= pipe.x + PIPE_WIDTH then 
        -- y-axis collision 
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then 
            return true
        end
    end 
    
    return false
end