return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.open()
                end,
                desc = "REPL",
            },
        },
    },
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        keys = {
            {
                "<leader>dt",
                function()
                    require("dap-go").debug_test()
                end,
                desc = "Debug Test",
            },
            {
                "<leader>dl",
                function()
                    require("dap-go").debug_last_test()
                end,
                desc = "Debug Last Test",
            },
        },
        opts = {},
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "Toggle DAP UI",
            },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            require("dap-go").setup()
            dap.listeners.after.event_initialized["dapui"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui"] = function()
                dapui.close()
            end
        end,
    },
}
