PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- update the timer
    self.timer = self.timer + dt

    -- spawn a pipe every 2 seconds
    if self.timer > 2 then 
        -- record that last gap location to base next one from it
        -- only so they're not too far apart (or else it'd be impossible to play)
        local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(self.lastY + math.random(-10, 10), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
        --  reset timer
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        -- score a point if the bird successfully passes the entire pipe
        -- ensure it hasn't already been scored (no duplicates)
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then 
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        pair:update(dt)
    end

    -- removes pipe pairs once off-screen
    -- if done in the loop above, indicies get mixed up
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then 
            table.remove(self.pipePairs, k)
        end
    end

    -- collision detection 
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- update the bird
    self.bird:update(dt)

    -- ground collision detection 
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })  
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    scrolling = false
end