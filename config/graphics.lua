return {
    window = {
        width  = 640,
        height = 360,
        scale  = 3,
        fullscreen = false,
        resizable  = false,
    },

    pixel_art = {
        filter = "nearest",
        snap_positions = true,
    },

    camera = {
        smoothing = 0.12,
        deadzone  = { x = 40, y = 30 },
    },

    layers = {
        background = 0,
        tilemap    = 10,
        entities   = 20,
        ui         = 100,
    },
}
