local M = {}

local config

local function rowglow_status_column()
  -- FIXME: This may be should call a function to get config?
  -- Need to confirm that just setting abs/rel is enough to enable, in which case we remove
  local dual = config.dual_columns

  local wo = vim.wo[vim.g.statusline_winid]
  local items = { '%s' }

  local abs_line
  local rel_line

  -- FIXME: This will need bolding with a test for the current line
  if vim.v.lnum == vim.fn.line('.') then
    table.insert(items, '%#RowGlowAbs#')
  end
  if tonumber(vim.v.lnum) < 100 then
    -- stylua: ignore
    abs_line = '%#RowGlowAbs#'
    .. vim.v.lnum
    .. " "
  else
    num_str = tostring(vim.v.lnum)
    abs_line = '%#LineNr#'
      .. num_str:sub(1, #num_str - 2)
      .. '%#RowGlowAbs#'
      .. string.format('%02d', vim.v.lnum % 100)
      .. ' '
  end
  table.insert(items, abs_line)

  if dual then
    -- stylua: ignore
    rel_line = "%#RowGlowRel#%r"
    table.insert(items, rel_line)
  end
  -- This is not a regular | character
  table.insert(items, '%=│')

  return table.concat(items)
end

local function setup(user_config)
  config = require('rowglow.config').merge_config(user_config)

  vim.api.nvim_set_hl(0, 'RowGlowAbs', { fg = config.colors.absolute })
  vim.api.nvim_set_hl(0, 'RowGlowRel', { fg = config.colors.relative })
  vim.opt.statuscolumn = "%!v:lua.require('rowglow').rowglow_status_column()"
end

M = {
  setup = setup,
  rowglow_status_column = rowglow_status_column,
}

return M
