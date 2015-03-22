import           XMonad
import           System.Exit
import           XMonad.Config.Gnome
import           XMonad.Util.Replace

-- Data & Control
import           Data.Monoid
import           Control.Arrow ((&&&),first)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Actions
import           XMonad.Actions.CycleWS
import           XMonad.Actions.Launcher
import           XMonad.Actions.Search
import           XMonad.Prompt
import           XMonad.Prompt.Shell

import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S

-- Layout
import           XMonad.Layout.Minimize

-- Looks
import           XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import           System.IO
import           XMonad.Util.Run -- for spawnPipe and hPutstrLn
  
-- Environment
import System.Directory
import System.IO.Unsafe
import XMonad.Hooks.SetWMName

-- | Programs used: dmenu, dzen2

-- | Initiates xmonad
--main = replace >> (xmonad xConfig)
main = do
  replace
  dzenLeftBar <- spawnPipe myXmonadBar
  --dzenRightBar <- spawnPipe myStatusBar
  --(xmonad =<< dzen xConfig)
  xmonad $ gnomeConfig{
    terminal           = "gnome-terminal",
    focusFollowsMouse  = False,
  
    ------------------------------
    --    mask     |    key       |
    ------------------------------
    --   mod1Mask  |  left alt    |
    --   mod3Mask  |  right alt   |
    --   mod4Mask  |  windows key |
    ------------------------------
  modMask            = mod4Mask,
  workspaces         = ["1","bitpaga","dart-haskell","shell","5","6","translate","browser","9"],
  startupHook = myStartupHook,
  
  normalBorderColor  = "#242424",
  focusedBorderColor = "#ff0000", 
  borderWidth        = 3,
  
  keys               = myKeys
  --mouseBindings      = myMouseBindings,
  
  -- hooks, layouts
  , layoutHook         = myLayout
  , manageHook         = myManageHook
  --handleEventHook    = myEventHook,
}

-- | XPrompt emacs-like key bindings
promptKeys :: M.Map (KeyMask,KeySym) (XP ())
promptKeys = M.fromList $
  map (first $ (,) controlMask) -- control + <key>
  [ (xK_z, killBefore) --kill line backwards
  , (xK_k, killAfter) -- kill line fowards
  , (xK_a, startOfLine) --move to the beginning of the line
  , (xK_e, endOfLine) -- move to the end of the line
  , (xK_m, deleteString Next) -- delete a character foward
  , (xK_b, moveCursor Prev) -- move cursor forward
  , (xK_f, moveCursor Next) -- move cursor backward
  , (xK_BackSpace, killWord Prev) -- kill the previous word
  , (xK_y, pasteString)  
  , (xK_g, quit)
  , (xK_bracketleft, quit)
  ] ++
  map (first $ (,) mod4Mask) -- meta key + <key>
  [ (xK_BackSpace, killWord Prev)
  , (xK_f, moveWord Next) -- move a word forward
  , (xK_b, moveWord Prev) -- move a word backward
  , (xK_d, killWord Next) -- kill the next word
  , (xK_n, moveHistory W.focusUp')
  , (xK_p, moveHistory W.focusDown')
  ]
  ++
  map (first $ (,) 0) -- <key>
  [ (xK_Return, setSuccess True >> setDone True)
  , (xK_KP_Enter, setSuccess True >> setDone True)
  , (xK_BackSpace, deleteString Prev)
  , (xK_Delete, deleteString Next)
  , (xK_Left, moveCursor Prev)
  , (xK_Right, moveCursor Next)
  , (xK_Home, startOfLine)
  , (xK_End, endOfLine)
  , (xK_Down, moveHistory W.focusUp')
  , (xK_Up, moveHistory W.focusDown')
  , (xK_Escape, quit)
  ]

-- | XPrompt config
promptConfig =
    XPC { font              = "-misc-fixed-*-*-*-*-20-*-*-*-*-*-*-*"
        , bgColor           = "grey7"
        , fgColor           = "grey80"
        , bgHLight          = "peru"
        , fgHLight          = "DarkGreen"
        , borderColor       = "gray3"
        , promptBorderWidth = 1
        , promptKeymap      = promptKeys
        , completionKey     = xK_Tab
        , changeModeKey     = xK_grave
        , position          = Bottom
        , height            = 60
        , historySize       = 256
        , historyFilter     = id
        , defaultText       = []
        , autoComplete      = Nothing
        , showCompletionOnTab = True
        , searchPredicate   = isPrefixOf
        , alwaysHighlight   = True
        }

-- | Which program should open a file 
extPrograms :: M.Map String (String -> X())
extPrograms = M.fromList $ 
   [
     (".el", \p -> spawn $ "emacsclient " ++ p)
   , (".hs", \p -> spawn $ "emacsclient " ++ p)
   , (".com", \p -> spawn $ "conkeror " ++ p)
   , (".pdf", \p -> spawn $ "acroread " ++ p)
   , (".", \p -> spawn $ "emacsclient " ++ p)
   ]

home :: FilePath
home = unsafePerformIO getHomeDirectory
  
-- | Configuration for launcher
launcherConfig = LauncherConfig { 
  pathToHoogle = home ++ "/.cabal/bin/hoogle", 
  browser = "conkeror" 
  }

-- | XMonad key bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    [    
      -- Xmonad.Actions.Launcher
      ((modm .|. controlMask, xK_x), launcherPrompt promptConfig $ defaultLauncherModes launcherConfig),
      -- Xmonad.Prompt.Shell
      ((modm .|. controlMask, xK_c), shellPrompt promptConfig), 
      
      -- Spawn a terminal
      ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
 
      -- Spawn dmenu
      ((modm, xK_space), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\""), 
      
      -- Close window
      ((modm .|. shiftMask, xK_w     ), kill),
      
      -- Next layout
      ((modm, xK_grave ), sendMessage NextLayout),
      
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_grave ), setLayout $ XMonad.layoutHook conf), 
      
      -- Resize viewed windows to the correct size
      ((modm, xK_j ), refresh),
        
      -- File Explorer
      ((modm, xK_Up ), spawn "nautilus ~"),
      
      -- Move focus to the next window
      ((modm, xK_Tab ), windows W.focusDown),      
      ((modm, xK_n ), windows W.focusDown),
 
      -- Move focus to the previous window
      ((modm .|. shiftMask , xK_Tab ), windows W.focusUp ),
      ((modm, xK_p ), windows W.focusUp ),
 
      -- Minimize 
      ((modm, xK_m ), withFocused minimizeWindow ),
      ((modm .|. shiftMask, xK_m ), sendMessage RestoreNextMinimizedWin),
 
      -- Swap the focused window and the master window
      ((modm, xK_Return), windows W.swapMaster), 
 
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modm,               xK_a     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
        
      -- Take screenshot and open its folder right away 
    , ((modm  , xK_apostrophe), spawn "scrot -e 'mv $f ~/Desktop' && nemo ~/Desktop" ) 

      -- favorite browser
    , ((modm              , xK_c), spawn "/home/kmels/bin/conkeror")
      
      -- favorite editor
    , ((modm              , xK_e), spawn "emacs")
            
      --Search
    , ((modm, xK_s), SM.submap $ searchEngineMap $ S.promptSearch promptConfig) 
    , ((modm .|. shiftMask, xK_s), SM.submap $ searchEngineMap $ S.selectSearch)
      
      -- Grid select
--      , ((modm, xK_g), goToSelected defaultGSConfig)
        
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
      
      -- a basic CycleWS setup
      
      -- get the next workspace visible (and shift)
    , ((modm,               xK_Right),  nextWS)
    , ((modm .|. shiftMask, xK_Right),  shiftToNext)  
      
      -- get the previous workspace visible
    , ((modm,               xK_Left),    prevWS)          
    , ((modm .|. shiftMask, xK_Left),    shiftToPrev)            
      
      -- toggle to the workspace displayed previously
    , ((modm,               xK_z),     toggleWS)
        
      -- Quit xmonad
    --, ((modm .|. shiftMask, xK_p     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
        	
    ++ 
    -- for numpad    
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) numPadKeys
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    ++            

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_bracketright, xK_backslash] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]    

-- Non-numeric num pad keys, sorted by number 
numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
             , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
             , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
             , xK_KP_Insert] -- 0	
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))            
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
 
        
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll [
  manageHook gnomeConfig
  , className =? "Clementine" --> doShift "music"
  , className =? "Xchat" --> doShift "talk"
  , className =? "Skype" --> doShift "talk"
  , className =? "Unity-2d-panel" --> doIgnore
  , className =? "Unity-2d-shell" --> doFloat
  , className =? "Unity-2d-launcher" --> doFloat
  ]
               
--myManageHook = composeOne [
  --isKDETrayWindow -?> doIgnore,
  --transience,
  --isFullscreen -?> doFullFloat,
  --resource =? "stalonetray" -?> doIgnore  
--  ]
------------------------------------------------------------------------
-- Event handling
 
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
--myEventHook = mempty
 
------------------------------------------------------------------------
-- Status bars and logging
--myLogHook :: Handle -> X ()

------------------------------------------------------------------------
-- Startup hook
 
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
myStartupHook = setWMName "LG3D"
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
searchEngineMap method = M.fromList $
       [ ((0, xK_g), method S.google)
       , ((0, xK_h), method S.hoogle)
       , ((0, xK_w), method S.wikipedia)
       , ((0, xK_y), method S.youtube)
       ]

myGManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doFloat
    ])

------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts $ tiled ||| minimize (Tall 1 (3/100) (1/2)) ||| tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
 
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- Dzen/Conky
myXmonadBar = "dzen2 -x '1440' -y '0' -h '24' -w '640' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
myStatusBar = "conky -c /home/kmels/.xmonad/.conky_dzen | dzen2 -x '2080' -w '1040' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"
myBitmapsDir = "/home/kmels/.xmonad/bitmaps"
