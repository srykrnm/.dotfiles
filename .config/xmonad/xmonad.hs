--------------------------------------------------------------------------

-- MY XMONAD CONFIG --

--------------------------------------------------------------------------
-- Modules --

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import qualified XMonad.StackSet as W
import XMonad.Util.SpawnOnce (spawnOnce)
import qualified Data.Map        as M
import XMonad.Actions.CycleWS (WSType (Not), moveTo, emptyWS, nextWS, prevWS, shiftToNext, shiftToPrev, toggleWS)
import XMonad.Hooks.ManageDocks
import XMonad.Actions.CopyWindow (copyToAll, killAllOtherCopies)
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.VoidBorders (normalBorders,voidBorders)
import XMonad.Hooks.ManageHelpers (doRectFloat)
import XMonad.Layout.Spacing (smartSpacingWithEdge, toggleWindowSpacingEnabled, toggleScreenSpacingEnabled )
import XMonad.Layout.LimitWindows (limitWindows)

--------------------------------------------------------------------------
-- Basic Settings --

myTerminal      = "st"
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
myClickJustFocuses :: Bool
myClickJustFocuses = False
myBorderWidth   = 1
myModMask       = mod4Mask
myWorkspaces    = ["www","ter","cht","mus","oth"]
myNormalBorderColor  = "#646464"
myFocusedBorderColor = "#ffffff"


--------------------------------------------------------------------------
-- Stolen (Centre floating window and toggle) --

centreRect = W.RationalRect 0.25 0.25 0.5 0.5

floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats 
       then f
       else n

centreFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

centreFloat' w = windows $ W.float w centreRect

standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()

toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused centreFloat')


--------------------------------------------------------------------------
-- Key bindings --

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((modm,               xK_p     ), spawn "dm-run")

    ,  ((0                     , xF86XK_AudioLowerVolume), spawn "multimedia adec")
    
    , ((modm, xK_s ), windows copyToAll) 

    , ((modm .|. shiftMask, xK_s ),  killAllOtherCopies) 

    ,  ((0                     , xF86XK_AudioRaiseVolume), spawn "multimedia ainc")

    ,  ((0                     , xF86XK_AudioPlay), spawn "multimedia aps")

    ,  ((0                     , xF86XK_AudioNext), spawn "multimedia anxt")

    ,  ((0                     , xF86XK_AudioPrev), spawn "multimedia aprev")

    ,  ((0                     , xF86XK_AudioMute), spawn "multimedia atogg")

    , ((0, xF86XK_MonBrightnessUp), spawn "multimedia binc")
   
    , ((0, xF86XK_MonBrightnessDown), spawn "multimedia bdec")

    , ((0,                   xK_Print    ), spawn "flameshot screen")

    , ((modm,                xK_Print    ), spawn "flameshot launcher")

    , ((modm,                xK_d    ), spawn "rofi -show drun")

    , ((modm,                xK_i    ), spawn "dunst_info")

    , ((modm,                xK_b    ), spawn "polybar-msg cmd toggle")
    
    , ((modm,                xK_q     ), kill)

    , ((modm,               xK_space ), sendMessage NextLayout)

    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    , ((modm,               xK_n     ), refresh)

    , ((modm,               xK_Tab   ), windows W.focusDown)

    , ((modm,               xK_j     ), windows W.focusDown)

    , ((modm,               xK_k     ), windows W.focusUp  )

    , ((modm .|. shiftMask, xK_Tab     ), windows W.focusUp  )

    , ((modm,               xK_m     ), windows W.focusMaster  )

    , ((modm,               xK_Return), windows W.swapMaster)

    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    , ((modm,               xK_h     ), sendMessage Shrink)

    , ((modm,               xK_l     ), sendMessage Expand)

    , ((modm,               xK_Up),  nextWS)

    , ((modm,               xK_z),  sequence_ [toggleWindowSpacingEnabled, toggleScreenSpacingEnabled])

    , ((modm,               xK_Right), moveTo Next (Not emptyWS))

    , ((modm,               xK_Left),  moveTo Prev (Not emptyWS))

    , ((modm,               xK_Down),    prevWS)

    , ((modm .|. shiftMask, xK_Up),  shiftToNext >> nextWS)

    , ((modm .|. shiftMask, xK_Down),    shiftToPrev >> prevWS)

    , ((modm,               xK_a),    toggleWS)

    , ((modm,               xK_t ), toggleFloat)

    , ((modm,               xK_slash ), spawn "dm-sw")
   
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    , ((modm .|. shiftMask, xK_q     ), spawn "dm-ex")

    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


--------------------------------------------------------------------------
-- Mouse bindings -- 

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w))

    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

--------------------------------------------------------------------------
-- Layouts --

myLayout = avoidStruts ( smartSpacingWithEdge 5 $ voidBorders Full |||  normalBorders  tiled ||| Mirror ( limitWindows 4 $ Tall 1 (3/100) (1/2)))
  where
     tiled   = limitWindows 4 
               $ Tall nmaster delta ratio

     nmaster = 1

     ratio   = 1/2

     delta   = 3/100

--------------------------------------------------------------------------
-- Window rules --

myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , className =? "Com.github.jmoerman.go-for-it"      --> doRectFloat(W.RationalRect 0.35 0.19 0.3 0.6)
    , className =? "Brave"      --> doRectFloat(W.RationalRect 0.25 0.25 0.5 0.5)  ]

--------------------------------------------------------------------------
-- Event handling --

myEventHook = mempty

--------------------------------------------------------------------------
-- Status bars and logging --

myLogHook = return ()

--------------------------------------------------------------------------
-- Startup hook --

myStartupHook = do
	spawnOnce "picom&"
	spawnOnce "polybar&"
	spawnOnce "batterynotify&"
	spawnOnce "updatesnotify&"

--------------------------------------------------------------------------
-- Main --

main = xmonad  $  ewmhFullscreen $ ewmh $ docks defaults

defaults = def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
	
--------------------------------------------------------------------------
-- END --
