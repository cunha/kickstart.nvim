local M = {}

function M.yank_with_context()
  -- 1. Get the visual selection range
  local line_start = vim.fn.line 'v'
  local line_end = vim.fn.line '.'
  vim.api.nvim_input '<Esc>'

  -- 2. Get the text within that range
  -- n.b. 'lines' is a table of strings
  local lines = vim.fn.getline(line_start, line_end)
  local selection_text = table.concat(lines, '\n')

  -- 3. Gather metadata
  local full_path = vim.fn.expand '%:.'
  -- local file_type = vim.bo.filetype -- Get the syntax (e.g., 'python', 'csv')

  -- 4. Construct the final string
  local result = string.format('%s:%d-%d\n```\n%s\n```', full_path, line_start, line_end, selection_text)

  local ns_id = vim.api.nvim_create_namespace 'yank_with_context_highlight'

  -- 5. Send to the system clipboard (+)
  vim.fn.setreg('+', result)

  -- 6. Highlight selected region
  vim.hl.range(0, ns_id, 'IncSearch', { line_start - 1, 0 }, { line_end - 1, 1000 }, {
    priority = 100,
    timeout = 250,
  })
end

function M.setup(options)
  vim.keymap.set('v', options.keybind, M.yank_with_context, { desc = 'Yank relative path context' })
end

return M


