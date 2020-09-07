== About ==
Standard UIDropDownMenu global functions using protected frames and causing taints 
when used by third-party addons. But it is possible to avoid taints by using same 
functionality with that library.

== What is it ==
Library is standard code from Blizzard's files EasyMenu.lua, UIDropDownMenu.lua, 
UIDropDownMenu.xml and UIDropDownMenuTemplates.xml with frames, tables, variables 
and functions renamed to:
* constants : "L_" added at the start
* functions: "L_" added at the start

== How to use it (for addon developer) ==
* Embed LibUIDropDownMenu to your addon, you can specify to the folder to 
  LibUIDropDownMenu\LibUIDropDownMenu if you feel this keep the folder cleaner.
* Add LibUIDropDownMenu.xml to your toc or your embeds.xml / libs.xml. 
* If your addon doesn't embed LibStub, you will need it.
* Like ordinal code for UIDropDownMenu with "L_" instead.

== Constants ==
* L_UIDROPDOWNMENU_MINBUTTONS
* L_UIDROPDOWNMENU_MAXBUTTONS
* L_UIDROPDOWNMENU_MAXLEVELS
* L_UIDROPDOWNMENU_BUTTON_HEIGHT
* L_UIDROPDOWNMENU_BORDER_HEIGHT
* L_UIDROPDOWNMENU_OPEN_MENU
* L_UIDROPDOWNMENU_INIT_MENU
* L_UIDROPDOWNMENU_MENU_LEVEL
* L_UIDROPDOWNMENU_MENU_VALUE
* L_UIDROPDOWNMENU_SHOW_TIME
* L_UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT
* L_OPEN_DROPDOWNMENUS

== Functions ==
* L_EasyMenu
* L_EasyMenu_Initialize

* L_UIDropDownMenuDelegate_OnAttributeChanged
* L_UIDropDownMenu_InitializeHelper
* L_UIDropDownMenu_Initialize
* L_UIDropDownMenu_SetInitializeFunction
* L_UIDropDownMenu_RefreshDropDownSize
* L_UIDropDownMenu_OnUpdate
* L_UIDropDownMenu_StartCounting
* L_UIDropDownMenu_StopCounting
* L_UIDropDownMenu_CheckAddCustomFrame
* L_UIDropDownMenu_CreateInfo
* L_UIDropDownMenu_CreateFrames
* L_UIDropDownMenu_AddSeparator
* L_UIDropDownMenu_AddButton
* L_UIDropDownMenu_AddSeparator
* L_UIDropDownMenu_GetMaxButtonWidth
* L_UIDropDownMenu_GetButtonWidth
* L_UIDropDownMenu_Refresh
* L_UIDropDownMenu_RefreshAll
* L_UIDropDownMenu_RegisterCustomFrame
* L_UIDropDownMenu_SetIconImage
* L_UIDropDownMenu_SetSelectedName
* L_UIDropDownMenu_SetSelectedValue
* L_UIDropDownMenu_SetSelectedID
* L_UIDropDownMenu_GetSelectedName
* L_UIDropDownMenu_GetSelectedID
* L_UIDropDownMenu_GetSelectedValue
* L_UIDropDownMenuButton_OnClick
* L_HideDropDownMenu
* L_ToggleDropDownMenu
* L_CloseDropDownMenus
* L_UIDropDownMenu_OnHide
* L_UIDropDownMenu_SetWidth
* L_UIDropDownMenu_SetButtonWidth
* L_UIDropDownMenu_SetText
* L_UIDropDownMenu_GetText
* L_UIDropDownMenu_ClearAll
* L_UIDropDownMenu_JustifyText
* L_UIDropDownMenu_SetAnchor
* L_UIDropDownMenu_GetCurrentDropDown
* L_UIDropDownMenuButton_GetChecked
* L_UIDropDownMenuButton_GetName
* L_UIDropDownMenuButton_OpenColorPicker
* L_UIDropDownMenu_DisableButton
* L_UIDropDownMenu_EnableButton
* L_UIDropDownMenu_SetButtonText
* L_UIDropDownMenu_SetButtonNotClickable
* L_UIDropDownMenu_SetButtonClickable
* L_UIDropDownMenu_DisableDropDown
* L_UIDropDownMenu_EnableDropDown
* L_UIDropDownMenu_IsEnabled
* L_UIDropDownMenu_GetValue

== List of button attributes ==
* info.text = [STRING]  --  The text of the button
* info.value = [ANYTHING]  --  The value that L_UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
* info.func = [function()]  --  The function that is called when you click the button
* info.checked = [nil, true, function]  --  Check the button if true or function returns true
* info.isNotRadio = [nil, true]  --  Check the button uses radial image if false check box image if true
* info.isTitle = [nil, true]  --  If it's a title the button is disabled and the font color is set to yellow
* info.disabled = [nil, true]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
* info.tooltipWhileDisabled = [nil, 1] -- Show the tooltip, even when the button is disabled.
* info.hasArrow = [nil, true]  --  Show the expand arrow for multilevel menus
* info.hasColorSwatch = [nil, true]  --  Show color swatch or not, for color selection
* info.r = [1 - 255]  --  Red color value of the color swatch
* info.g = [1 - 255]  --  Green color value of the color swatch
* info.b = [1 - 255]  --  Blue color value of the color swatch
* info.colorCode = [STRING] -- "|cAARRGGBB" embedded hex value of the button text color. Only used when button is enabled
* info.swatchFunc = [function()]  --  Function called by the color picker on color change
* info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
* info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
* info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
* info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
* info.notClickable = [nil, 1]  --  Disable the button and color the font white
* info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
* info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
* info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
* info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
* info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
* info.tooltipOnButton = [nil, 1] -- Show the tooltip attached to the button instead of as a Newbie tooltip.
* info.justifyH = [nil, "CENTER"] -- Justify button text
* info.arg1 = [ANYTHING] -- This is the first argument used by info.func
* info.arg2 = [ANYTHING] -- This is the second argument used by info.func
* info.fontObject = [FONT] -- font object replacement for Normal and Highlight
* info.menuTable = [TABLE] -- This contains an array of info tables to be displayed as a child menu
* info.noClickSound = [nil, 1]  --  Set to 1 to suppress the sound when clicking the button. The sound only plays if .func is set.
* info.padding = [nil, NUMBER] -- Number of pixels to pad the text on the right side
* info.leftPadding = [nil, NUMBER] -- Number of pixels to pad the button on the left side
* info.minWidth = [nil, NUMBER] -- Minimum width for this line
* info.customFrame = frame -- Allows this button to be a completely custom frame, should inherit from L_UIDropDownCustomMenuEntryTemplate and override appropriate methods.