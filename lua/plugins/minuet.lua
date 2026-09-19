return {
    {
        "milanglacier/minuet-ai.nvim",
        keys = {
            { "<A-]>", mode = "i" },
            { "<A-[>", mode = "i" },
        },
        opts = {
            provider = "openai_fim_compatible",
            provider_options = {
                openai_fim_compatible = {
                    -- Ollama 不校验这个 key，随便指一个肯定存在的环境变量名
                    -- 糊弄过去就行，不用为此单独造一个假 secret。
                    api_key = "TERM",
                    name = "Ollama",
                    end_point = "http://localhost:11434/v1/completions",
                    model = "qwen2.5-coder:1.5b",
                    optional = {
                        max_tokens = 56,
                        top_p = 0.9,
                    },
                },
            },
            virtualtext = {
                -- 这台机器只有核显、本地 CPU 推理，不能每次打字都发请求
                -- （会明显卡），所以关掉自动触发，全部手动按键触发。
                auto_trigger_ft = {},
                keymap = {
                    accept = "<A-A>",
                    accept_line = "<A-a>",
                    accept_n_lines = "<A-z>",
                    -- 没有建议时按 next/prev 就是手动发起一次补全请求
                    prev = "<A-[>",
                    next = "<A-]>",
                    dismiss = "<A-e>",
                },
            },
        },
    },
}
