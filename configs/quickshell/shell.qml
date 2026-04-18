import Quickshell
import NyxDE.ImageAnalyser
import "modules/bar"

ShellRoot {
    // Analyse current wallpaper — update source when wallpaper changes
    ImageAnalyser {
        id: wallAnalyser
        source: "/home/mahrjose/.config/hyde/themes/Catppuccin Mocha/wallpapers/wallhaven-lyk98y_1920x1080.png"
    }

    Bar {
        accentColor: wallAnalyser.dominantColor
        isDark: wallAnalyser.luminance < 0.4
    }
}
