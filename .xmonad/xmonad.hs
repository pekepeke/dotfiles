-- vim:fdm=marker sw=2 ts=2 ft=haskell expandtab:
import System.IO
import System.Exit

import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowGo
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import Data.Monoid

import qualified Data.Map as M
import qualified XMonad.Actions.ConstrainedResize as Sqr
import qualified XMonad.StackSet as W

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "killall trayer; xmonad --recompile; xmonad --restart")
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    -- GridSelect
    [((modm, xK_g), goToSelected defaultGSConfig)]

myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> Sqr.mouseResizeWindow w False >> windows W.shiftMaster)) --it's actually my right button, I've switched it with the middle one
    , ((modm, button3), (\w -> windows $ W.shiftMaster . W.focusUp . W.swapDown)) --try to bring under-floating up; works fine with two floating windows
    , ((modm, button4), (\_ -> windows W.focusUp))
    , ((modm, button5), (\_ -> windows W.focusDown))
    , ((modm .|. shiftMask, button2), (\w -> focus w >> Sqr.mouseResizeWindow w True >> windows W.shiftMaster))
    , ((modm .|. shiftMask, button4), (\_ -> windows W.swapUp))
    , ((modm .|. shiftMask, button5), (\_ -> windows W.swapDown))
    -- , ((modm .|. controlMask, button4), (\_ -> prevWS))
    -- , ((modm .|. controlMask, button5), (\_ -> nextWS))
    ]

myLayout = withBorder 1 (tiled ||| Mirror tiled ||| Grid) ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

main = do
  spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 20 --transparent true --tint 0x000000 --height 12"
  spawn "gnome-power-manager"
  spawn "gnome-volume-control-applet"
  spawn "nm-applet --sm-disable"
  spawn "bluetooth-applet"
  spawn "nautilus --no-desktop -n"
  -- spawn "dropbox start"
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
    { 
    logHook = dynamicLogWithPP $ xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "green" "" . shorten 50
      }
    , manageHook = manageDocks <+> manageHook defaultConfig
    -- , layoutHook = avoidStruts $ layoutHook defaultConfig
    , layoutHook         = myLayout
    , terminal           = "urxvt"
    , borderWidth        = 2
    , normalBorderColor  = "#dddddd"
    , focusedBorderColor = "#ff0000"
    , workspaces         = ["1","2","3","4","5","6","7","8","9"]
     -- key bindings
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
    }
