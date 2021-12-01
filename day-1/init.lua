require "lua-string"

local linq = require("lazylualinq")
local client = require("client")

local measurements = linq.from(client:getDayInput(1):trim():split("\n"))
    :select(function(v, k) return tonumber(v), k end)

local function puzzle1()
    return measurements:zip(
            measurements:skip(1), 
            function(curr, _, next) 
                return { curr = curr, next = next } 
            end)
        :where(function(t, k) return t.next > t.curr end)
        :count()
end

return {
    puzzle1 = puzzle1(),
}