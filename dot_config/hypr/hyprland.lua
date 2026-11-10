-- https://wiki.hyprland.org/Configuring/

---------------------------
------ ENV EXEC ETC ------
--------------------------
require("./env-exec-etc.lua")
require("./themes/theme.lua")

----------------------
------ MONITORS ------
----------------------
require("./monitors.lua")

-------------------------
------ KEYBINDINGS ------
-------------------------
require("./keybindings.lua")

-------------------
------ INPUT ------
-------------------
require("./input.lua")

---------------------------
------ LOOK AND FEEL ------
---------------------------
require("./look-and-feel.lua")
require("./animations.lua")

------------------------------------
------ WINDOWS AND WORKSPACES ------
------------------------------------
require("./workspaces-windowrules.lua")

------ PLUGINS ------
-- require("./plugins.lua")

------ DYNAMIC IMPORTS LIKE DARKMODE ------
require("./dynamic-imports.lua")

------ EXPERIMENTAL OVERRIDES ------
require("./.overrides.lua")
