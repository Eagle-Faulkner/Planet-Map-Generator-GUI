#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance

Version = 1.0.0
UserDataDir = %A_WorkingDir%
UserSavesDir = %A_WorkingDir%

GoSub, LoadColFiles
GoSub, LoadPrefs
GoSub, DrawGUIMain
Return

DrawGUIMain:
	;Create Option "Save map" in "File"
	Menu, MenuFile, Add, &Save Map, NoUse
	;Create Option "Save image" in "File"
	Menu, MenuFile, Add, &Save Image, NoUse
	;Create Option "Load Map" in "File"
	Menu, MenuFile, Add, &Load Map, LoadMap

	;Create Menu "File"
	Menu, MenuBar, Add, &File, :MenuFile

	;Create Manubar
	Gui, Main: Menu, MenuBar

	;Seed
	Gui, Main: Add, Text, x10 y10 w100, Seed:
	Gui, Main: Add, Button, x95 yp w100 gRandSeed, Random
	Gui, Main: Add, Edit, x210 yp w100 Number Limit vMapSeed, %MapSeed%

	;Map size
	Gui, Main: Add, Text, x10 yp+25, Map Size(px):
	Gui, Main: Add, Edit, x95 yp w100 Number Limit4 vMapW, %MapW%
	Gui, Main: Add, Text, x200 yp, X
	Gui, Main: Add, Edit, x210 yp w100 Number Limit4 VMapH, %MapH%

	;Zoom
	Gui, Main: Add, Text, x10 yp+25, Magnification:
	Gui, Main: Add, Edit, x210 yp W100 Number Limit VMapZoom , %MapZoom%

	;Map center
	Gui, Main: Add, Text, x10 yp+25, Map Center:
	Gui, Main: Add, Edit, x95 yp w100 Number Limit4 vMapCenterW, %MapCenterW%
	Gui, Main: Add, Text, x200 yp, `,
	Gui, Main: Add, Edit, x210 yp w100 Number Limit4 VMapCenterH, %MapCenterH%

	;Viewing center
	Gui, Main: Add, Text, x10 yp+25, Viewing Center:
	Gui, Main: Add, Edit, x95 yp w100 Number Limit4 vMapViewW, %MapViewW%
	Gui, Main: Add, Text, x200 yp, `,
	Gui, Main: Add, Edit, x210 yp w100 Number Limit4 VMapViewH, %MapViewH%

	;Grid
	Gui, Main: Add, Text, x10 yp+25, Grid(0 for no grid):
	Gui, Main: Add, Edit, x95 yp w100 Number Limit vMapGridW, %MapGridW%
	Gui, Main: Add, Text, x200 yp, X
	Gui, Main: Add, Edit, x210 yp w100 Number Limit VMapGridH, %MapGridH%

	;Base Altitude
	Gui, Main: Add, Text, x10 yp+25, Base altitude:
	Gui, Main: Add, Edit, x210 yp w100 Limit VMapBaseAlt, %MapBaseAlt%

	;Latitude Coloring
	Gui, Main: Add, Text, x10 yp+25, Latitude coloring:
	Gui, Main: Add, Button, x95 yp w100 gSubtractLatColor, -
	Gui, Main: Add, Button, x210 yp w100 gAddLatColor, +
	Gui, Main: Add, Text, xp+101 yp w30 vMapLatColorNum, %MapLatColorNum%

	;Non-linear Altitude
	Gui, Main: Add, Checkbox, x10 yp+25 vMapHasLinAlt Checked%MapHasLinAlt%, Linear Altitude

	;Wrinkly Map
	Gui, Main: Add, Checkbox, x10 yp+25 vMapIsWrinkly Checked%MapIsWrinkly%, Wrinkly Map

	;Coloring
	Gui, Main: Add, Text, x10 yp+25, Coloring:
	Gui, Main: Add, DDL, x95 yp w215 vMapCol, %ColOptions%
	GuiControl, Main: ChooseString, MapCol, %MapCol%

	;Black and White
	Gui, Main: Add, Checkbox, x10 yp+25 vMapIsBW Checked%MapIsBW%, Black and White outline only

	;Trace land edges
	Gui, Main: Add, Checkbox, x10 yp+25 vMapHasEdges Checked%MapHasEdges%, Edges around map

	;BumpMap Shading
	Gui, Main: Add, DDL, xp yp+25 w100 Altsubmit vBumpMapChoice Choose%BumpMapChoice%, No Bumpmap|Land Bumpmap|Full Bumpmap

	;Distance Contribution
	Gui, Main: Add, Text, x10 yp+25, Distance Contribution:
	Gui, Main: Add, Edit, x210 yp w100 vMapDistCont, %MapDistCont%

	;Altitude Contribution
	Gui, Main: Add, Text, x10 yp+25, Altitude Contribution:
	Gui, Main: Add, Edit, x210 yp w100 vMapAltCont, %MapAltCont%

	;Projection Type
	Gui, Main: Add, Text, x10 yp+25, Projection Type:
	Gui, Main: Add, DDL, x210 yp w100 AltSubmit vMapProjectionChoice Choose%MapProjectionChoice%, Mercator|Peters|Square|Stereographic|Orthographic|Gnomonic|Area Preserving Azimuthal|Conical(conformal)|Mollweide|Sinusoidal|Heightfield(obsolete)|Icosohedral

	;Daylight Shading
	Gui, Main: Add, Checkbox, x10 yp+25 vMapHasDaylight Checked%MapHasDaylight%, Daylight Shading

	;Daylight Angle/Sun Longitude
	Gui, Main: Add, Text, x10 yp+25, Sun longitude:
	Gui, Main: Add, Edit, x210 yp w100 vMapSunLo, %MapSunLo%

	;Sun Latitude
	Gui, Main: Add, Text, x10 yp+25, Sun latitude:
	Gui, Main: Add, Edit, x210 yp w100 vMapSunLat, %MapSunLat%


	Gui, Main: Add, Button, x10 yp+50 gUpdateMap, Update Map
	Gui, Main: Add, Text, xp yp+25, Preview
	Gui, Main: Add, Picture, x350 y10 w500 h-1 vMapImageDisplayer, Temp.bmp

	Gui, Main: Show, autosize center Maximize
Return

LoadMap:
	FileSelectFile, LoadThisMap
	IniRead, MapW, %LoadThisMap%, DefaultVars, MapW , 300
	IniRead, MapH, %LoadThisMap%, DefaultVars, MapH , 150
	IniRead, MapZoom, %LoadThisMap%, DefaultVars, MapZoom , 1
	IniRead, MapCenterW, %LoadThisMap%, DefaultVars, MapCenterW , 0
	IniRead, MapCenterH, %LoadThisMap%, DefaultVars, MapCenterH , 0
	IniRead, MapGridW, %LoadThisMap%, DefaultVars, MapGridW , 0
	IniRead, MapGridH, %LoadThisMap%, DefaultVars, MapGridH , 0
	IniRead, MapBaseAlt, %LoadThisMap%, DefaultVars, MapBaseAlt , -0.02
	IniRead, MapLatColorNum, %LoadThisMap%, DefaultVars, MapLatColorNum , 0
	IniRead, MapLatColor, %LoadThisMap%, DefaultVars, MapLatColor , %A_Space%
	IniRead, MapHasLinAlt, %LoadThisMap%, DefaultVars, MapHasLinAlt , 1
	IniRead, MapIsWrinkly, %LoadThisMap%, DefaultVars, MapIsWrinkly , 0
	IniRead, MapCol, %LoadThisMap%, DefaultVars, MapCol , default
	IniRead, MapIsBW, %LoadThisMap%, DefaultVars, MapIsBW , 0
	IniRead, MapHasEdges, %LoadThisMap%, DefaultVars, MapHasEdges , 0
	IniRead, BumpMapChoice, %LoadThisMap%, DefaultVars, BumpMapChoice , 1
	IniRead, MapDistCont, %LoadThisMap%, DefaultVars, MapDistCont , 0.035
	IniRead, MapAltCont, %LoadThisMap%, DefaultVars, MapAltCont , 0.45
	IniRead, MapProjectionChoice, %LoadThisMap%, DefaultVars, MapProjectionChoice , 1
	IniRead, MapHasDaylight, %LoadThisMap%, DefaultVars, MapHasDaylight , 0
	IniRead, MapSunLo, %LoadThisMap%, DefaultVars, MapSunLo , 0
	IniRead, MapSunLat, %LoadThisMap%, DefaultVars, MapSunLat , 0
	Gui, Main: Destroy
	GoSub, DrawGUIMain
Return

LoadPrefs:
	IniRead, MapSeed, %UserDataDir%\UserData.ini, DefaultVars, MapSeed , 0
	If MapSeed = 0
		{
		Gosub, RandSeed
		}
	IniRead, MapW, %UserDataDir%\UserData.ini, DefaultVars, MapW , 300
	IniRead, MapH, %UserDataDir%\UserData.ini, DefaultVars, MapH , 150
	IniRead, MapZoom, %UserDataDir%\UserData.ini, DefaultVars, MapZoom , 1
	IniRead, MapCenterW, %UserDataDir%\UserData.ini, DefaultVars, MapCenterW , 0
	IniRead, MapCenterH, %UserDataDir%\UserData.ini, DefaultVars, MapCenterH , 0
	IniRead, MapGridW, %UserDataDir%\UserData.ini, DefaultVars, MapGridW , 0
	IniRead, MapGridH, %UserDataDir%\UserData.ini, DefaultVars, MapGridH , 0
	IniRead, MapBaseAlt, %UserDataDir%\UserData.ini, DefaultVars, MapBaseAlt , -0.02
	IniRead, MapLatColorNum, %UserDataDir%\UserData.ini, DefaultVars, MapLatColorNum , 0
	IniRead, MapLatColor, %UserDataDir%\UserData.ini, DefaultVars, MapLatColor , %A_Space%
	IniRead, MapHasLinAlt, %UserDataDir%\UserData.ini, DefaultVars, MapHasLinAlt , 1
	IniRead, MapIsWrinkly, %UserDataDir%\UserData.ini, DefaultVars, MapIsWrinkly , 0
	IniRead, MapCol, %UserDataDir%\UserData.ini, DefaultVars, MapCol , default
	IniRead, MapIsBW, %UserDataDir%\UserData.ini, DefaultVars, MapIsBW , 0
	IniRead, MapHasEdges, %UserDataDir%\UserData.ini, DefaultVars, MapHasEdges , 0
	IniRead, BumpMapChoice, %UserDataDir%\UserData.ini, DefaultVars, BumpMapChoice , 1
	IniRead, MapDistCont, %UserDataDir%\UserData.ini, DefaultVars, MapDistCont , 0.035
	IniRead, MapAltCont, %UserDataDir%\UserData.ini, DefaultVars, MapAltCont , 0.45
	IniRead, MapProjectionChoice, %UserDataDir%\UserData.ini, DefaultVars, MapProjectionChoice , 1
	IniRead, MapHasDaylight, %UserDataDir%\UserData.ini, DefaultVars, MapHasDaylight , 0
	IniRead, MapSunLo, %UserDataDir%\UserData.ini, DefaultVars, MapSunLo , 0
	IniRead, MapSunLat, %UserDataDir%\UserData.ini, DefaultVars, MapSunLat , 0
Return

SubtractLatColor:
	StringTrimRight, MapLatColor, MapLatColor, 3
	If MapLatColorNum > 0
		{
		MapLatColorNum -= 1
		GuiControl, Main:, MapLatColorNum, %MapLatColorNum%
		}
Return

AddLatColor:
	MapLatColor = %MapLatColor% -c
	MapLatColorNum += 1
	GuiControl, Main:, MapLatColorNum, %MapLatColorNum%
Return

CreateCommand:
	Gui, Main: Submit, nohide
	If MapHasLinAlt
		{
		MapLinAlt = 
		}
	Else
		{
		MapLinAlt = -n
		}
	If MapIsWrinkly
		{
		MapWrinkle = -S
		}
	Else
		{
		MapWrinkle = 
		}
	If MapIsBW
		{
		MapBW = -O
		}
	Else
		{
		MapBW = 
		}
	If MapHasEdges
		{
		MapEdges = -E
		}
	Else
		{
		MapEdges = 
		}
	If BumpMapChoice = 2
		{
		MapBump = -b
		}
	Else If BumpMapChoice = 3
		{
		MapBump = -B
		}
	Else
		{
		MapBump = 
		}
	If MapProjectionChoice = 1
		{
		MapProjection = m
		}
	Else If MapProjectionChoice = 2
		{
		MapProjection = p
		}
	Else If MapProjectionChoice = 3
		{
		MapProjection = q
		}
	Else If MapProjectionChoice = 4
		{
		MapProjection = s
		}
	Else If MapProjectionChoice = 5
		{
		MapProjection = o
		}
	Else If MapProjectionChoice = 6
		{
		MapProjection = g
		}
	Else If MapProjectionChoice = 7
		{
		MapProjection = a
		}
	Else If MapProjectionChoice = 8
		{
		MapProjection = c
		}
	Else If MapProjectionChoice = 9
		{
		MapProjection = M
		}
	Else If MapProjectionChoice = 10
		{
		MapProjection = S
		}
	Else If MapProjectionChoice = 11
		{
		MapProjection = h
		}
	Else If MapProjectionChoice = 12
		{
		MapProjection = i
		}
	If MapHasDaylight
		{
		MapDaylight = -d
		}
	Else
		{
		MapDaylight = 
		}
	Command = planet -s 0.%MapSeed% -w %MapW% -h %MapH% -m %MapZoom% -T %MapCenterW% -l %MapViewW% -L %MapViewH% %MapCenterH% -g %MapGridW% -G %MapGridH% -i %MapBaseAlt% %MapLatColor% %MapLinAlt% %MapWrinkle% -C %MapCol%.col %MapBW% %MapEdges% %MapBump% -V %MapDistCont% -v %MapAltCont% -p %MapProjection% %MapDaylight% -a %MapSunLo% -A %MapSunLat% -o Temp.bmp
Return

UpdateMap:
	GoSub, CreateCommand
	RunWait, %Command%
	GuiControl, Main:, MapImageDisplayer, *w625 *h-1 Temp.bmp
Return

LoadColFiles:
	Loop, Files, %A_WorkingDir%\*.col
		{
		ColOptions = %ColOptions%|%A_LoopFileName%
		StringTrimRight, ColOptions, ColOptions, 4
		}
	StringTrimLeft, ColOptions, ColOptions, 1
Return

RandSeed:
	Random, MapSeed, 0, 99999999999999999
	GuiControl, Main:, MapSeed, %MapSeed%
Return

NoUse:
	MsgBox This feature not yet implemented
Return

MainGuiClose:
MainGuiEscape:
ExitApp