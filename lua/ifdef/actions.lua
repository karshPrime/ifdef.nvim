local Helpers = require("ifdef.helpers")

local Actions = {}

--# Auto-refresh Call #-----------------------------------------------------------------

function Actions.auto_refresh_record(config, enable)
    if config.auto_refresh then
        Helpers.update_defines(enable)
    end
end

function Actions.current()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local labels = {}

    for _, define in ipairs(Helpers.defines) do
        if define.start > line_num then
            break
        end

        if define.start < line_num and line_num < define.finish then
            table.insert(labels, define.label)
        end
    end

    print(table.concat(labels, " { "))
end

function Actions.comment_end()
    -- Implementation for comment-end
end

function Actions.tree()
    -- Implementation for tree
end

return Actions

