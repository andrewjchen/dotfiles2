    import XMonad hiding (Tall)
    import XMonad.Hooks.DynamicLog
    import XMonad.Hooks.ManageDocks

    import XMonad.Actions.FloatKeys
    import XMonad.Layout.HintedTile
    import XMonad.Layout.LayoutHints (layoutHints)
    import XMonad.Layout.ResizableTile
    import XMonad.Layout.Tabbed
    import XMonad.Layout.NoBorders
    import XMonad.Layout
    import XMonad.Layout.WindowArranger
    import XMonad.Hooks.SetWMName

    import XMonad.Layout.Fullscreen
    import XMonad.Layout.NoBorders

    import XMonad.Prompt
    import XMonad.Prompt.Shell
    import XMonad.Util.Run(spawnPipe)
    import XMonad.Hooks.UrgencyHook

    import System.Exit
    import System.IO
    import Data.Monoid

    import qualified XMonad.StackSet as W
    import qualified Data.Map        as M

    import XMonad.Hooks.EwmhDesktops


    myBorderWidth   = 1
    main = do
        h0 <- spawnPipe "/usr/bin/xmobar /home/ajc/.xmobarrc -x 0"
        h1 <- spawnPipe "/usr/bin/xmobar /home/ajc/.xmobarrc -x 1"
        xmonad $ withUrgencyHookC FocusHook urgentConfig $ myConfig h0 h1
    myConfig h0 h1 =  defaultConfig {
            terminal             = "gnome-terminal"
            , startupHook        = setWMName "LG3D"
            , modMask            = mod4Mask
            , workspaces         = ["~", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "<<"]
            , normalBorderColor  = "#404040"
            , focusedBorderColor = "#00ff00"
            , manageHook         = myManageHook --composeAll [],
            , handleEventHook    = XMonad.Hooks.EwmhDesktops.fullscreenEventHook
            --, manageHook         = composeAll []  --myManageHook,--composeAll [],
            , borderWidth        = myBorderWidth
            , keys               = myKeys
            --, layoutHook         = avoidStruts $ windowArrange myLayout
            , layoutHook         = windowArrange myLayout
            , logHook            = logHook' h0 h1
        }
    logHook' h0 h1 = dynamicLogWithPP xmobarPP {
                                     ppOutput = hPutStrLn h0,
                                     ppTitle = xmobarColor "#00ff00" "" . shorten 50,
                                     ppHiddenNoWindows = xmobarColor "#808080" "",
                                     ppHidden = xmobarColor "#bbbbbb" "",
                                     ppVisible = xmobarColor "white" "#006293" . wrap " " " ",
                                     ppCurrent = xmobarColor "white" "#00aaff" . wrap " " " "
                                 }
                        >>
                        dynamicLogWithPP xmobarPP {
                                     ppOutput = hPutStrLn h1,
                                     ppTitle = xmobarColor "#00ff00" "" . shorten 50,
                                     ppHiddenNoWindows = xmobarColor "#808080" "",
                                     ppHidden = xmobarColor "#bbbbbb" "",
                                     ppVisible = xmobarColor "white" "#006293" . wrap " " " ",
                                     ppCurrent = xmobarColor "white" "#00aaff" . wrap " " " " }

    -- urgent notification
    urgentConfig = UrgencyConfig { suppressWhen = Focused, remindWhen = Dont }


    myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

        [ ((modMask              , xK_Return   ), spawn $ XMonad.terminal conf)
        , ((modMask .|. shiftMask, xK_c        ), kill)
        , ((modMask              , xK_space    ), sendMessage NextLayout)
        , ((modMask .|. shiftMask, xK_space    ), setLayout $ XMonad.layoutHook conf)
        , ((modMask              , xK_n        ), refresh)
        --, ((modMask,               xK_p     ), spawn "exe=`dmenu_path | dmenu -b ` && eval \"exec $exe\"")
        -- we want to use our own dmenu
        , ((modMask,               xK_p     ), spawn "exe=`dmenu_run -b -nb '#000000' -sb '#0066FF' -sf '#ffffff' -nf '#ffffff' ` && eval \"exec $exe\"")
        , ((modMask              , xK_Tab      ), windows W.focusDown)
        , ((modMask              , xK_j        ), windows W.focusDown)
        , ((modMask              , xK_k        ), windows W.focusUp)
        , ((modMask              , xK_m        ), windows W.focusMaster)
        , ((modMask .|. shiftMask, xK_Return   ), windows W.swapMaster)
        , ((modMask .|. shiftMask, xK_j        ), windows W.swapDown)
        , ((modMask .|. shiftMask, xK_k        ), windows W.swapUp)
        , ((modMask              , xK_h        ), sendMessage Shrink)
        , ((modMask              , xK_l        ), sendMessage Expand)
        , ((modMask              , xK_t        ), withFocused $ windows . W.sink)
        , ((modMask              , xK_comma    ), sendMessage (IncMasterN 1))
        , ((modMask              , xK_period   ), sendMessage (IncMasterN (-1)))
        , ((modMask .|. shiftMask, xK_q        ), io (exitWith ExitSuccess))
        , ((modMask              , xK_q        ), spawn "xmonad --recompile; xmonad --restart")
        , ((modMask              , xK_F2       ), shellPrompt defaultXPConfig)
        , ((0                    , 0x1008ff30  ), shellPrompt defaultXPConfig)
        , ((0                    , 0x1008ff13  ), spawn "amixer -q set Master 1dB+")
        , ((0                    , 0x1008ff11  ), spawn "amixer -q set Master 1dB-")
        --, ((0                    , 0x1008ff12  ), spawn "amixer -q set Master toggle")
        , ((0                    , 0x1008ff16  ), spawn "cmus-remote --prev")
        , ((0                    , 0x1008ff17  ), spawn "cmus-remote --next")
        , ((0                    , 0x1008ff14  ), spawn "cmus-remote --pause")
        , ((0                    , 0x1008ff5b  ), spawn "urxvt -e screen -rd cmus")
        , ((modMask              , xK_Print    ), spawn "scrot -e 'mv $f ~/System/Screenshots'")
        --resize float
        --, ((modMask            , xK_f         ), withFocused (keysResizeWindow (-10,-10) (1,1)))
        --, ((modMask                , xK_g         ), withFocused (keysResizeWindow (10,10) (1,1)))
        --, ((modMask                , xK_w         ), withFocused (keysMoveWindow (0, -10)))
        --, ((modMask                , xK_a         ), withFocused (keysMoveWindow (-10 ,0)))
        --, ((modMask                , xK_s         ), withFocused (keysMoveWindow (0,10)))
        --, ((modMask                , xK_d         ), withFocused (keysMoveWindow (10,0)))
      --, ((modMask .|. shiftMask, xK_d     ), withFocused (keysAbsResizeWindow (-10,-10) (1024,752)))
      --, ((modMask .|. shiftMask, xK_s     ), withFocused (keysAbsResizeWindow (10,10) (1024,752)))


        --ResizeableTile layout bindings
        , ((modMask             , xK_x          ), sendMessage MirrorShrink)
        , ((modMask             , xK_z          ), sendMessage MirrorExpand)
        , ((modMask  .|. controlMask              , xK_s    ), sendMessage  Arrange         )
        , ((modMask  .|. controlMask .|. shiftMask, xK_s    ), sendMessage  DeArrange       )
--        , ((modMask  .|. controlMask              , xK_Left ), sendMessage (MoveLeft      1))
--        , ((modMask  .|. controlMask              , xK_Right), sendMessage (MoveRight     1))
--        , ((modMask  .|. controlMask              , xK_Down ), sendMessage (MoveDown      1))
--        , ((modMask  .|. controlMask              , xK_Up   ), sendMessage (MoveUp        1))
        , ((modMask                  .|. shiftMask, xK_Left ), sendMessage (IncreaseLeft  1))
        , ((modMask                  .|. shiftMask, xK_Right), sendMessage (IncreaseRight 1))
        , ((modMask                  .|. shiftMask, xK_Down ), sendMessage (IncreaseDown  1))
        , ((modMask                  .|. shiftMask, xK_Up   ), sendMessage (IncreaseUp    1))
        , ((modMask  .|. controlMask .|. shiftMask, xK_Left ), sendMessage (DecreaseLeft  1))
        , ((modMask  .|. controlMask .|. shiftMask, xK_Right), sendMessage (DecreaseRight 1))
        , ((modMask  .|. controlMask .|. shiftMask, xK_Down ), sendMessage (DecreaseDown  1))
        , ((modMask  .|. controlMask .|. shiftMask, xK_Up   ), sendMessage (DecreaseUp    1))

        , ((modMask                         , xK_Home), spawn "sudo /etc/acpi/sleep.sh")
        , ((modMask                         , xK_Delete         ), spawn "synclient TouchpadOff=1")
        , ((modMask                         , xK_Insert         ), spawn "synclient TouchpadOff=0")
        --, ((modMask                         , xK_Insert         ), spawn "xinput set-prop 12 \"Device Enabled\" 1")
        , ((modMask                         , xK_Pause         ), spawn "xrandr --output VGA1 --auto --left-of LVDS1")
        , ((modMask                         , xK_Scroll_Lock         ), spawn "xrandr --output VGA1 --off")
        --screenoff
        , ((modMask                         , xK_Escape         ), spawn "sleep 1 && xset dpms force off")
        --fan controlg
        --sounds!
        , ((modMask                         , xK_F1         ), spawn "/usr/bin/gnome-terminal -e /usr/bin/ranger")

        ]
        ++

        [((m .|. modMask, k), windows $ f i)
            | (i, k) <- zip (XMonad.workspaces conf) [xK_grave, xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_minus, xK_equal, xK_BackSpace]
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

        ++

        [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
            | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..] --xK_y used to be --xK_w
            , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


    --myLayout = smartBorders $ (tiled ||| Mirror tiled ||| Full ||| simpleTabbed)
    myLayout = avoidStruts(
                smartBorders $ (tiled ||| Mirror tiled ||| Full ||| simpleTabbed)) ||| noBorders(fullscreenFull Full) 
      where
        tiled = ResizableTall nmaster delta ratio []
        nmaster = 1--number of master windows
        delta = 3/100 --change of resizing actions
        ratio = 1/2 --width of master

    myManageHook :: ManageHook
    myManageHook = composeAll . concat $
        [ [ className   =? c                 --> doFloat | c <- myFloats]
        , [ title       =? t                 --> doFloat | t <- myOtherFloats]
        , [ resource    =? r                 --> doIgnore | r <- myIgnores]
        ]
        where
            myIgnores       = ["panel"]
            myFloats        = ["feh", "GIMP", "gimp", "gimp-2.4", "Galculator", "VirtualBox", "VBoxSDL", "mplayer", "original-left", "original-right", "disparity", "grayscale", "Processing"]
            myOtherFloats   = ["alsamixer", "Bon Echo Preferences", "Mail/News Preferences", "Bon Echo - Restore Previous Session", "RXPlot"]


