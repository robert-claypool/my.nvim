return {
  -- Extend Flexoki's markdown highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local function setup_extra_markdown_highlights()
        local is_light = vim.o.background == "light"
        
        -- Match Flexoki palette colors
        local colors = {
          red = is_light and "#af3029" or "#d14d41",
          orange = is_light and "#bc5215" or "#da702c", 
          yellow = is_light and "#8E6B01" or "#d0a215",
          green = is_light and "#536907" or "#879a39",
          cyan = is_light and "#1C6C66" or "#3aa99f",
          blue = is_light and "#205ea6" or "#4385be",
          purple = is_light and "#5e409d" or "#8b7ec8",
          magenta = is_light and "#a02f6f" or "#ce5d97",
        }
        
        -- Bold/italic markers need color to be visible
        vim.cmd(string.format("hi @punctuation.special.markdown guifg=%s gui=bold", colors.orange))
        vim.cmd(string.format("hi @conceal.markdown guifg=%s gui=bold", colors.orange))
        
        -- Support older treesitter versions
        vim.cmd(string.format("hi @text.strong.delimiter guifg=%s gui=bold", colors.orange))
        vim.cmd(string.format("hi @text.emphasis.delimiter guifg=%s", colors.yellow))
        
        -- Current treesitter emphasis markers
        vim.cmd(string.format("hi @markup.strong.markdown_inline guifg=%s gui=bold", colors.orange))
        vim.cmd(string.format("hi @markup.italic.markdown_inline guifg=%s gui=italic", colors.yellow))
        vim.cmd(string.format("hi @markup.emphasis.delimiter.markdown_inline guifg=%s", colors.yellow))
        vim.cmd(string.format("hi @markup.strong.delimiter.markdown_inline guifg=%s gui=bold", colors.orange))
        
        -- Table delimiters
        vim.cmd(string.format("hi @punctuation.special.markdown.table guifg=%s", colors.purple))
        
        -- Footnotes
        vim.cmd(string.format("hi @markup.footnote.markdown guifg=%s", colors.cyan))
        vim.cmd(string.format("hi @markup.footnote.marker.markdown guifg=%s gui=bold", colors.cyan))
        
        -- Definition lists
        vim.cmd(string.format("hi @markup.definition.markdown guifg=%s", colors.green))
        
        -- Task list markers
        vim.cmd(string.format("hi @markup.list.task.markdown guifg=%s gui=bold", colors.orange))
        
        -- HTML entities in markdown
        vim.cmd(string.format("hi @string.special.markdown guifg=%s", colors.yellow))
        
        -- Frontmatter
        vim.cmd(string.format("hi @markup.metadata.markdown guifg=%s", colors.purple))
        
        -- Code block delimiters
        vim.cmd(string.format("hi @punctuation.delimiter.markdown_inline guifg=%s gui=bold", colors.magenta))
        
        -- Reference links
        vim.cmd(string.format("hi @markup.link.reference.markdown guifg=%s", colors.blue))
        
        -- Inline HTML
        vim.cmd(string.format("hi @tag.markdown guifg=%s", colors.orange))
        vim.cmd(string.format("hi @tag.attribute.markdown guifg=%s", colors.yellow))
        vim.cmd(string.format("hi @tag.delimiter.markdown guifg=%s", colors.orange))
      end
      
      -- Reapply when theme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = setup_extra_markdown_highlights,
      })
      
      setup_extra_markdown_highlights()
    end,
  },
}