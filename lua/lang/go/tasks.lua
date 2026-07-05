local task = require("core.tasks")
local root = require("core.root")
task.register("go:run", {
    cmd = { "go", "run", "." },
    cwd = root.go(),
})
task.register("go:build", {
    cmd = { "go", "build", "./..." },
    cwd = root.go(),
})
task.register("go:test", {
    cmd = { "go", "test", "." },
    cwd = root.go(),
})
task.register("go:test-all", {
    cmd = { "go", "test", "./..." },
    cwd = root.go(),
})
task.register("go:bench", {
    cmd = { "go", "test", "-bench", "." },
    cwd = root.go(),
})
task.register("go:coverage", {
    cmd = {
        "go",
        "test",
        "-coverprofile=coverage.out",
        ".",
    },
    cwd = root.go(),
})
task.register("go:tidy", {
    cmd = { "go", "mod", "tidy" },
    cwd = root.go(),
})
task.register("go:generate", {
    cmd = { "go", "generate", "./..." },
    cwd = root.go(),
})
