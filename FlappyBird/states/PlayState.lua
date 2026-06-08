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
            end
        end
    end

    pair:update(dt)
end
