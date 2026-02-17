local Helpers = {}

Helpers.defines = {}

local PATTERNS = {
    ifdef = "%s*#ifdef%s+(%S+)",
    ifndef = "%s*#ifndef%s+(%S+)",
    else_dir = "%s*#else",
    elif = "%s*#elif%s+(%S+)",
    endif = "%s*#endif",
}

local VALID_EXTENSIONS = { c = true, h = true, cpp = true }

function Helpers.update_defines(enabled)
    if not enabled then
        return
    end

    Helpers.defines = {}
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local stack = {}

    for line_num, line in ipairs(lines) do
        local define_label

        define_label = line:match(PATTERNS.ifdef)
        if define_label then
            table.insert(stack, {
                label = define_label,
                start = line_num,
                finish = 0,
                endif = false,
            })
            table.insert(Helpers.defines, stack[#stack])
            goto continue
        end

        define_label = line:match(PATTERNS.ifndef)
        if define_label then
            table.insert(stack, {
                label = "!" .. define_label,
                start = line_num,
                finish = 0,
                endif = false,
            })
            table.insert(Helpers.defines, stack[#stack])
            goto continue
        end

        if line:match(PATTERNS.else_dir) then
            local current = stack[#stack]
            if current then
                current.finish = line_num

                local new_entry = {
                    label = (current.label:sub(1, 1) == "!" and current.label:sub(2)) or ("!" .. current.label),
                    start = line_num,
                    finish = 0,
                    endif = false,
                }
                stack[#stack] = new_entry
                table.insert(Helpers.defines, new_entry)
            end
            goto continue
        end

        define_label = line:match(PATTERNS.elif)
        if define_label then
            local current = stack[#stack]
            if current then
                current.finish = line_num

                local new_entry = {
                    label = define_label,
                    start = line_num,
                    finish = 0,
                    endif = false,
                }
                stack[#stack] = new_entry
                table.insert(Helpers.defines, new_entry)
            end
            goto continue
        end

        if line:match(PATTERNS.endif) then
            local current = stack[#stack]
            if current then
                current.finish = line_num
                current.endif = true
                table.remove(stack)
            end
        end

        ::continue::
    end
end

function Helpers.valid_file()
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = filename:match("%.([^.]+)$")
    return extension and VALID_EXTENSIONS[extension] or false
end

return Helpers

