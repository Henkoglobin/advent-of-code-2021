# Advent of Code 2021

[Advent of Code](https://adventofcode.com/2021) is a site that puts up two programming puzzles for each day leading up to Christmas. It's a nice way to enjoy some recreative coding, and I especially use it as a chance to use [lazylualinq](https://github.com/Henkoglobin/lazylualinq) productively, fixing bugs and adding missing functions in the meantime.

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
