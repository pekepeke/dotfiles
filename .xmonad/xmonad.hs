-- vim:fdm=marker sw=2 ts=2 ft=haskell expandtab:
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
            , layoutHook = avoidStruts $ layoutHook defaultConfig
                , logHook = dynamicLogWithPP $ xmobarPP
                { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                }
            , terminal           = "gnome-terminal"
                , borderWidth        = 2
                , normalBorderColor  = "#333333"
                , focusedBorderColor = "#cd8b00"
        }
