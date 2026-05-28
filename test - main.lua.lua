--
-- Variables
--

-- global (accessible from other Lua modules)
Hello = 'hello'

-- local (accessible only in this scope)
local world = ' world!'

--
-- Functions
--

-- declaring our function
function Say(text)
    print(text)
end

-- calling our function (note the .. operator to concatenate strings!)
Say(Hello .. world)