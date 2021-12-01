# Advent of Code 2021

## Building and Running

This project depends on a number of rocks; it's assumed that they are installed in the ./lib directory:

```bash
luarocks install --dev --tree ./lib lazylualinq
luarocks install --tree ./lib http
luarocks install --tree ./lib lua-string
```

Additionally, you'll have to provide your token from [Advent of Code](https://adventofcode.com/2021)'s `session` Cookie in a file called `.token`. Then, run:

```bash
lua -l bootstrap main.lua
```
