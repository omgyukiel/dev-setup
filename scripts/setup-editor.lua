local report = { tools = {}, errors = {} }
local function setup()
  require('lazy').load({ plugins = { 'mason.nvim', 'nvim-lspconfig', 'nvim-treesitter', 'blink.cmp' } })
  local registry = require('mason-registry')
  local refreshed = false
  registry.refresh(function() refreshed = true end)
  assert(vim.wait(60000, function() return refreshed end, 100), 'Mason registry refresh timed out')
  local packages = {}
  for _, name in ipairs({ 'stylua', 'shfmt', 'markdown-toc', 'markdownlint-cli2', 'pyright', 'ruff', 'json-lsp', 'lua-language-server' }) do
    local pkg = registry.get_package(name)
    packages[name] = pkg
    if not pkg:is_installed() and not pkg:is_installing() then pkg:install() end
  end
  assert(vim.wait(240000, function()
    for _, pkg in pairs(packages) do
      if pkg:is_installing() then return false end
    end
    return true
  end, 100), 'Language tool installation timed out')
  for name, pkg in pairs(packages) do
    report.tools[name] = pkg:is_installed()
    assert(report.tools[name], 'Language tool installation failed: ' .. name)
  end
  local languages = { 'bash', 'c', 'diff', 'html', 'javascript', 'jsdoc', 'json', 'json5', 'lua', 'luadoc', 'luap', 'markdown', 'markdown_inline', 'ninja', 'printf', 'python', 'query', 'regex', 'rst', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'xml', 'yaml' }
  require('nvim-treesitter').install(languages):wait(180000)
  for _, language in ipairs(languages) do
    assert(pcall(vim.treesitter.language.add, language), 'Parser missing or invalid: ' .. language)
  end
  report.parser_count = #languages
  vim.cmd('doautocmd User VeryLazy')
  report.theme = vim.g.colors_name
  report.navigation = vim.fn.exists(':TmuxNavigateLeft') == 2
  assert(report.navigation, 'tmux navigation plugin did not load')
  report.missing_plugins = {}
  for name, plugin in pairs(require('lazy.core.config').plugins) do
    if not vim.uv.fs_stat(plugin.dir) then table.insert(report.missing_plugins, name) end
  end
  assert(#report.missing_plugins == 0, 'Some editor plugins are missing')
end
local ok, err = pcall(setup)
if not ok then table.insert(report.errors, tostring(err)) end
local state = vim.fn.expand('~/.local/state/dev-setup')
vim.fn.mkdir(state, 'p')
vim.fn.writefile({ vim.json.encode(report) }, state .. '/editor-setup.json')
if not ok then
  vim.api.nvim_err_writeln(tostring(err))
  vim.cmd('cquit 1')
else
  print('Editor setup verified; report: ' .. state .. '/editor-setup.json')
  vim.cmd('qa!')
end
