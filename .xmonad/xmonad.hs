import XMonad
import Data.Monoid
import System.Exit
import XMonad.Config.Gnome 
import XMonad.Util.Replace

import XMonad.Actions.Search
import qualified XMonad.Actions.Submap as SM

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.ManageHelpers 
import XMonad.Prompt

import XMonad.Prompt.Input
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Shell
import XMonad.Prompt.Window
import XMonad.Prompt
import XMonad.Prompt.Ssh

import XMonad.Actions.CycleWS
import XMonad.Util.EZConfig
import qualified XMonad.Prompt as P
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S
import XMonad.Actions.GridSelect

import Control.Arrow ((&&&),first)

import XMonad.Actions.Launcher

--some code reading helpers
altMask = mod4Mask --this is the super key, but I have it remapped

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "terminator"
--myTerminal      = "gnome-terminal"
--myTerminal      = "urxvt -tr +sb -fg white -bg black -tint white -sh 75 -fade 15 -fadecolor black -pr black -pr2 white"
 
                  -- Whether focus follows the mouse pointer. 
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
 
-- Width of the window border in pixels.
--
myBorderWidth   = 3
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask
 
-- NOTE: from 0.9.1 on numlock mask is set automatically. The numlockMask
-- setting should be removed from configs.
--
-- You can safely remove this even on earlier xmonad versions unless you
-- need to set it to something other than the default mod2Mask, (e.g. OSX).
--
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
-- myNumlockMask   = mod2Mask -- deprecated in xmonad-0.9.1
------------------------------------------------------------
 
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
myWorkspaces    = ["maintask","browser","code","shell","windows","6","translate","mail","music"]
 

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

{---------------------------------------
 XPrompt key map; Fly in texts with emacs-like key bindings
----------------------------------------}
kmelsXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
kmelsXPKeymap = M.fromList $
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
  map (first $ (,) altMask) -- meta key + <key>
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

{---------------------------------------
 XPrompt config
----------------------------------------}
kmelsXPConfig =
    XPC { font              = "-misc-fixed-*-*-*-*-20-*-*-*-*-*-*-*"
        , bgColor           = "grey7"
        , fgColor           = "grey80"
        , bgHLight          = "peru"
        , fgHLight          = "DarkGreen"
        , borderColor       = "gray3"
        , promptBorderWidth = 1
        , promptKeymap      = kmelsXPKeymap
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
        }

{----------------------------------------
 Extension actions
 ---------------------------------------}
extensionActions :: M.Map String (String -> X())
extensionActions = M.fromList $ 
   [
     (".el", \p -> spawn $ "emacsclient " ++ p)
   , (".hs", \p -> spawn $ "emacsclient " ++ p)
   , (".com", \p -> spawn $ "conkeror " ++ p)
   , (".pdf", \p -> spawn $ "acroread " ++ p)
   , (".", \p -> spawn $ "emacsclient " ++ p)
   ]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    [    
      -- testing Xmonad.Prompt.Shell --
      ((modm .|. controlMask, xK_x), launcherPrompt kmelsXPConfig extensionActions)
     , ((modm .|. controlMask, xK_c), shellPrompt kmelsXPConfig)
      
      -- launch a terminal
     , ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
 
      -- launch dmenu
     , ((modm,               xK_space     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
 
    -- launch gmrun
--    --, ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
 
    -- close focused window
    , ((modm .|. shiftMask, xK_w     ), kill)    
 
     -- Rotate through the available layout algorithms
    , ((modm,               xK_grave ), sendMessage NextLayout)
      
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_grave ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_j     ), refresh)
 
      -- nautilus
    , ((modm,                 xK_Up    ), spawn "nautilus ~")
      
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modm,               xK_n     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modm,               xK_p     ), windows W.focusUp  )
 
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
    , ((modm,               xK_a     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
        
      -- Take screenshot and open its folder right away 
    , ((modm  , xK_apostrophe), spawn "scrot -e 'mv $f ~/Desktop' && nautilus ~/Desktop" ) 

      -- favorite browser
    , ((modm              , xK_b), spawn "~/bin/conkeror")
      
      -- favorite editor
    , ((modm              , xK_e), spawn "emacs")
            
      --Search
    , ((modm, xK_s), SM.submap $ searchEngineMap $ S.promptSearch P.defaultXPConfig) 
    , ((modm .|. shiftMask, xK_s), SM.submap $ searchEngineMap $ S.selectSearch)
      
      -- Grid select
      , ((modm, xK_g), goToSelected defaultGSConfig)
        
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
      
      -- a basic CycleWS setup
      
      -- get the next workspace visible (and shift)
    , ((modm,               xK_Right),  nextWS)
    , ((modm .|. shiftMask, xK_Right),  shiftToNext >> nextWS)  
      
      -- get the previous workspace visible
    , ((modm,               xK_Left),    prevWS)          
    , ((modm .|. shiftMask, xK_Left),    shiftToPrev >> prevWS)            
      
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
myLayout = tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
 
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
 
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
 
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
--myLogHook = return ()
 
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
--myStartupHook = return ()
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--
--main = xmonad defaults
searchEngineMap method = M.fromList $
       [ ((0, xK_g), method S.google)
       , ((0, xK_h), method S.hoogle)
       , ((0, xK_w), method S.wikipedia)
       , ((0, xK_y), method S.youtube)
       ]
       
kmelsConfig = gnomeConfig{
  terminal           = myTerminal,
  focusFollowsMouse  = myFocusFollowsMouse,
  borderWidth        = myBorderWidth,
  modMask            = myModMask,
  
  -- numlockMask deprecated in 0.9.1
  -- numlockMask        = myNumlockMask,
  workspaces         = myWorkspaces,
  normalBorderColor  = myNormalBorderColor,
  focusedBorderColor = myFocusedBorderColor,
  
  -- key bindings
  keys               = myKeys
  --mouseBindings      = myMouseBindings,
  
  -- hooks, layouts
  --           layoutHook         = myLayout
  , manageHook         = myManageHook
  --handleEventHook    = myEventHook,
}

--main = xmonad defaults 


myGManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doFloat
    ])

main = xmonad kmelsConfig 
--main = xmonad gnomeConfig { manageHook = myGkilManageHook }

