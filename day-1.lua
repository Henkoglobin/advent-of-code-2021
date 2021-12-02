require "lua-string"

local linq = require("lazylualinq")
local client = require("client")

return {
    init = function(self)
        self.measurements = linq.from(client:getDayInput(1):trim():split("\n"))
            :select(function(v, k) return tonumber(v), k end)
    end,

    puzzle1 = function(self)
        return self.measurements:zip(
            self.measurements:skip(1), 
            function(curr, _, next) 
                return { curr = curr, next = next } 
            end)
        :where(function(t) return t.next > t.curr end)
        :count()
    end,

    puzzle2 = function(self)
        -- This is an extremely messy way of building up the sliding window,
        -- it'd be way cooler to have this built-in in lazylualinq!
        local windows = self.measurements:zip(
            self.measurements:skip(1):zip(
                self.measurements:skip(2),
                function(b, _, c) return { b = b, c = c} end
            ),
            function(a, _, tuple)
                return { a = a, b = tuple.b, c = tuple.c }
            end
        )

        local sums = windows:select(function(w) return w.a + w.b + w.c end)

        return sums:zip(
                sums:skip(1),
                function(curr, _, next)
                    return { curr = curr, next = next }
                end)
            :where(function(t) return t.next > t.curr end)
            :count()
    end,
}