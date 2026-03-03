function love.conf(t)
    t.identity = "outsidebythemonhub"
    t.appendidentity = true
    t.window.title = "outside"
    t.window.icon = nil
    t.window.width = 800
    t.window.height = 600
    t.modules.physics = false
    t.modules.touch = false
    t.modules.data = false
    t.modules.vsync = 0
end