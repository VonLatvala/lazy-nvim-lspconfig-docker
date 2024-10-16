# NVIM Lazy lspconfig

## What's this?

A demo docker container for running NVIM with Lazy and lspconfig.

Tried to troubleshoot why I couldn't `require` lspconfig, turns out
this was my fault for putting the lspconfig setup file `lspconfig.lua`
into the module search path. This took me way too many hours to realize.

Fixed this by moving `~/.config/nvim/lua/lspconfig.lua` ->
`~/.config/nvim/lua/config/lspconfig.lua`.

BEWARE OF NAMING CLASHES!

## So now what?

This could function as a base for devcontainers etc. Might even use
it myself some day.

## Building

### Config

You may set a build variable to override the username for the non-root
user created. Please set `USERNAME` in that case. Defaults to `alatvala`.

With the newer buildx command

```sh
buildx build --tag lazy-nvim .
```

Or with the older style

```sh
buildx build --tag lazy-nvim .
```

## Author

Axel Latvala @VonLatvala
