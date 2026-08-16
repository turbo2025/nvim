return {
    {
        "mfussenegger/nvim-dap",
    },
    {
        "nvim-neotest/nvim-nio",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            --------------------------------------------------------
            -- Auto open/close
            --------------------------------------------------------
            dap.listeners.before.attach["dapui"] = function()
                dapui.open()
            end
            dap.listeners.before.launch["dapui"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui"] = function()
                dapui.close()
            end
        end,
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "DAP UI",
            },
        },
    },
}
