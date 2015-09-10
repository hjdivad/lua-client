package = 'nvim-client'
version = '0.0.1-13'
source = {
  url = 'https://github.com/neovim/lua-client/archive/' .. version .. '.tar.gz',
  dir = 'lua-client-' .. version,
}
description = {
  summary = 'Lua client to Nvim',
  license = 'Apache'
}
dependencies = {
  'lua ~> 5.1',
  'lua-messagepack',
  'coxpcall'
}
external_dependencies = {
  LIBUV = {
    header = 'uv.h'
  }
}

local function make_modules()
  return {
    ['nvim.msgpack_stream'] = 'nvim/msgpack_stream.lua',
    ['nvim.async_session'] = 'nvim/async_session.lua',
    ['nvim.session'] = 'nvim/session.lua',
    ['nvim.loop'] = {
      sources = {'nvim/loop.c'},
      incdirs = {"$(LIBUV_INCDIR)"},
      libdirs = {"$(LIBUV_LIBDIR)"}
    }
  }
end

local function make_libs()
  return {'uv', 'pthread'}
end

-- based on:
-- https://github.com/diegonehab/luasocket/blob/master/luasocket-scm-0.rockspec
local function make_plat(plat)
  local libs = make_libs()

  if plat == 'freebsd' then
    libs[#libs + 1] = 'kvm'
  end

  if plat == 'linux' then
    libs[#libs + 1] = 'rt'
    libs[#libs + 1] = 'dl'
  end

  return {
    libraries = libs,
  }
end

build = {
  type = 'builtin',
  -- default (platform-agnostic) configuration
  libraries = make_libs(),
  modules = make_modules(),

  -- per-platform overrides
  -- https://github.com/keplerproject/luarocks/wiki/Platform-agnostic-external-dependencies
  platforms = {
    linux = make_plat('linux'),
    freebsd = make_plat('freebsd')
  }
}