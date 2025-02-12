local _M = {
  terminal = 'alacritty',
  editor   = 'nvim',
  screenshot = 'maim ~/.cache/$(date +%s).png',
  screencrop = 'maim -s ~/.cache/$(date +%s).png',
  browser = 'firefox',
}

_M.editor_cmd = _M.terminal .. ' -e ' .. _M.editor
_M.manual_cmd = _M.terminal .. ' -e man awesome'
_M.file_manager = _M.terminal .. ' -e nnn -C'

return _M
