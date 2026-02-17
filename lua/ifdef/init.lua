-- ifdef.nvim
-- Inform what #ifdefs are surrounding current line

--# INITIALISE #------------------------------------------------------------------------------------

local Helpers = require("ifdef.helpers")
local Actions = require("ifdef.actions")

local M = {}

local enabled = true
M.config = {
    auto_refresh = true,
}

--# COMMAND DISPATCHER #----------------------------------------------------------------------------

function dispatch(args)
    if not Helpers.valid_file() then
        return 1
    end

    if args == "enable" then
        enabled = true
    elseif args == "disable" then
        enabled = false
    elseif args == "refresh" then
        Helpers.update_defines(enabled)
    elseif args == "current" then
        Actions.current()
    elseif args == "comment-end" then
        Actions.comment_end()
    elseif args == "tree" then
        Actions.tree()
    end
end

--# SETUP AUTOCOMMANDS #----------------------------------------------------------------------------

function M.setup()
    if not Helpers.valid_file() then
        return 1
    end

    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            Actions.auto_refresh_record(M.config, enabled)
        end
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
            Actions.auto_refresh_record(M.config, enabled)
        end
    })
end

-- Supported Commands
vim.api.nvim_create_user_command("Ifdef", function(args)
    dispatch(args.args)
end, {
    nargs = 1,
    complete = function()
        return { "refresh", "current", "comment-end", "tree", "disable", "enable" }
    end,
})

return M

