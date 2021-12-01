local version = _VERSION:match("%d+%.%d+")
package.path = 'lib/share/lua/' .. version .. '/?.lua;lib/share/lua/' .. version .. '/?/init.lua;' .. package.path
package.cpath = 'lib/lib/lua/' .. version .. '/?.so;' .. package.cpath