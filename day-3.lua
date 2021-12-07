require "lua-string"

local linq = require("lazylualinq")
local client = require("client")

return {
    init = function(self)
        self.reportData = linq.from(client:getDayInput(3):trim():split("\n"))
            :select(function(v, k) 
                local bits = linq.from(v:totable())
                    :select(function(bit, i) return tonumber(bit), i end)
                    :toArray()
                return bits, k 
            end)
    end,

    bitsToNumber = function(self, bits)
        -- This would be easier if lazylualinq already implemented reverse... (though only in conjunction with reindex)
        local len = #bits
        return linq.from(bits)
            -- Todo: I cheated a bit and changed aggregate to include the index in the selector call... 
            -- This better find its way to upstream :D
            :aggregate(0, function(agg, bit, index)
                -- I'd love to do math.pow(2 * bit, len - index), but Lua says that 0^0 == 1, so we'd be off-by-one if
                -- the last bit is unset.
                if bit == 0 then
                    return agg
                else
                    return agg + 2 ^ (len - index)
                end
            end)
    end,

    puzzle1 = function(self)
        local sums = self.reportData
            :aggregate(function(agg, curr)
                return linq.from(agg)
                    :zip(
                        linq.from(curr),
                        function(a, _, b) return a + b end
                    )
                    :toArray()
            end)

        local total = self.reportData:count()
        local resultBitsGamma = linq.from(sums)
            :select(function(sum) return (sum > total / 2) and 1 or 0 end)
            :toArray()

        -- No need to figure out the least common bit; it's the opposite of the gamma bit.
        local resultBitsEpsilon = linq.from(resultBitsGamma)
            :select(function(bit) return 1 - bit end)
            :toArray()

        local gamma = self:bitsToNumber(resultBitsGamma)

        -- We could also just do 2^#resultBitsGamma - 1 - gamma, but where's the fun in that?
        local epsilon = self:bitsToNumber(resultBitsEpsilon)

        return gamma * epsilon
    end,

    findByMostOrLeastCommonBit = function(self, mode)
        local firstLine = self.reportData:first()
        local numBits = #firstLine

        local preFiltered = self.reportData
        for i = 1, numBits do
            local count = preFiltered:count()

            if count == 1 then
                return preFiltered:single()
            end

            local sumAtIndex = preFiltered:sum(function(bits) return bits[i] end)

            local mostCommonBit = (sumAtIndex >= count / 2) and 1 or 0

            preFiltered = preFiltered:where(function(bits) 
                if mode == "most" then
                    return bits[i] == mostCommonBit
                else
                    return bits[i] ~= mostCommonBit 
                end
            end)
        end

        return preFiltered:single()
    end,

    puzzle2 = function(self)
        local oxygenGeneratorRatingBits = self:findByMostOrLeastCommonBit("most")
        local co2ScrubberRatingBits = self:findByMostOrLeastCommonBit("least")

        local oxygenGeneratorRating = self:bitsToNumber(oxygenGeneratorRatingBits)
        local co2ScrubberRatingBits = self:bitsToNumber(co2ScrubberRatingBits)

        return oxygenGeneratorRating * co2ScrubberRatingBits
    end,
}