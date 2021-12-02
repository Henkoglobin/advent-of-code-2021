require "lua-string"

local linq = require("lazylualinq")
local client = require("client")

return {
    init = function(self)
        self.instructions = linq.from(client:getDayInput(2):trim():split("\n"))
            :select(function(s) 
                local dir, rawDist = s:match("(%w+) (%d+)")
                return { dir = dir, dist = tonumber(rawDist) }
            end)
    end,

    puzzle1 = function(self)
        local depth, horizontal = 0, 0
    
        for entry in self.instructions:getIterator() do
            if entry.dir == "up" then
                depth = depth - entry.dist
            elseif entry.dir == "down" then
                depth = depth + entry.dist
            elseif entry.dir == "forward" then
                horizontal = horizontal + entry.dist
            end
        end
    
        return depth * horizontal
    end,

    puzzle2 = function(self)
        local depth, horizontal, aim = 0, 0, 0
    
        for entry in self.instructions:getIterator() do
            if entry.dir == "up" then
                aim = aim - entry.dist
            elseif entry.dir == "down" then
                aim = aim + entry.dist
            elseif entry.dir == "forward" then
                horizontal = horizontal + entry.dist
                depth = depth + aim * entry.dist
            end
        end
    
        return depth * horizontal
    end,
}
