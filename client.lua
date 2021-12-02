local httpRequest = require("http.request")
local httpCookie = require("http.cookie")

return {
    getToken = function(self)
        local f = io.open(".token", "r")
        local token = f:read("*l")
        f:close()
        return token
    end,
    getDayInput = function(self, day)
        local uri = ("https://adventofcode.com/2021/day/%d/input"):format(day)
        local request = httpRequest.new_from_uri(uri)

        request.cookie_store:store(
            "adventofcode.com",
            "/",
            true,
            true,
            nil,
            "session",
            self:getToken(),
            {}
        )

        local headers, stream = assert(request:go())
        local body = assert(stream:get_body_as_string())

        return body
    end,
}