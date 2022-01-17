__INSTANCE_SETTINGS__ =
{
  path =
  {
    db  = '/db/vk/',
    app = '/usr/share/tarantool/vk/'
  },
  host =
  {
    app     = '0.0.0.0:3344',
    console = '127.0.0.1:3131',
    httpd   = '0.0.0.0:8888'
  }
}

box.cfg
{
  listen = __INSTANCE_SETTINGS__.host.app,
  memtx_dir = __INSTANCE_SETTINGS__.path.db ..'memtx',
  vinyl_dir = __INSTANCE_SETTINGS__.path.db ..'vinyl',
  wal_dir = __INSTANCE_SETTINGS__.path.db ..'xlog',
  work_dir = __INSTANCE_SETTINGS__.path.app,
--  memtx_memory = 8192 * 1024 * 1024,
--  memtx_max_tuple_size = 8 * 1024 * 1024,
  log_level = 5,
}

require('console').listen(__INSTANCE_SETTINGS__.host.console)

dofile( __INSTANCE_SETTINGS__.path.app ..'init.lua' )
dofile(  __INSTANCE_SETTINGS__.path.app ..'hello.lua' )
