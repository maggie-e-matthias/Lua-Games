Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:followBall(ball)
    if ball.dy ~= 0 and ball.dx > 0 then
        if ball.dy < 0 then
            self.y = math.max(0, ball.y - 8)
        else
            self.y = ball.y - 8
        end
        self.dy = ball.dy * math.random(1, 3)
    else
        self.dy = 0
    end
end