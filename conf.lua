function love.conf(t)
    t.title             = "Haunted Maze"
    t.author            = "Thomas Shaffer"
    t.identity          = nil
    t.version           = 1
    t.console           = false
    t.screen.width      = 725
    t.screen.height     = 700
    t.screen.fullscreen = false
    t.screen.vsync      = true
    t.screen.fsaa       = 0
    t.modules.joystick  = false
    t.modules.audio     = false
    t.modules.keyboard  = true
    t.modules.event     = true
    t.modules.image     = true
    t.modules.graphics  = true
    t.modules.timer     = true
    t.modules.mouse     = false
    t.modules.sound     = false
    t.modules.physics   = false
end