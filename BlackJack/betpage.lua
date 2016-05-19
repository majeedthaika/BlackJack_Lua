-----------------------------------------------------------------------------------------
--
-- betpage.lua
--
-----------------------------------------------------------------------------------------
-- Require the widget library
local widget = require( "widget" )

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
-- Global Variables
bankAmount = 100000; -- the players money (TEST VAL! CHANGEME)
betAmount = 0; -- how much the player is betting

--------------------------------------------

-- forward declarations and other locals
local playBtn -- Play now button
local pickerWheel -- Drop down menu
local values -- Value of the picker wheel
local betLimits={ 1,3,10,30,100,300,1000,3000,10000,30000,100000,300000,1000000,3000000,10000000 }

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	-- Get the table of current values for all columns
	values = pickerWheel:getValues()

	-- Get the value for each column in the wheel (by column index)
	local betAmount = values[1].value
	
	if ((betAmount*2) <= bankAmount) then
		bankAmount = bankAmount - betAmount
		-- go to bjtable.lua scene
		local options = {
		effect = "fade",
		time = 500,
		params = {bankAmount=bankAmount,  betAmount=betAmount}
		}
		composer.gotoScene( "bjtable", options )
	else
		betText.text = "Invalid, Try again:"
	    betText.fontSize = 30
	    betText:setTextColor(1,0.2,0.2)
	end
	return true	-- indicates successful touch
end


function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "Table_Green_banner.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	-- display Text header
	local options = {
	    text = "Bet Amount:", -- supports up to 11 digits   
	    x = display.contentCenterX,
	    y = 30,
	    width = 300,
	    font = native.systemFontBold,   
	    fontSize = 30,
	    align = "center"  --new alignment parameter
	}
	betText = display.newText(options);
    betText:setTextColor(1,1,1)

	-- Configure the picker wheel columns
	local columnData = {
	    -- Bet Amount
	    { 
	        align = "center",
	        width = 270,
	        startIndex = 7,
	        labels = betLimits,
	        fontSize = 30,
	    },
	}

	-- Image sheet options and declaration
	local options = {
	    frames = 
	    {
	        { x=0, y=0, width=320, height=222 },
	        { x=320, y=0, width=320, height=222 },
	        { x=640, y=0, width=8, height=222 }
	    },
	    sheetContentWidth = 648,
	    sheetContentHeight = 222
	}
	local pickerWheelSheet = graphics.newImageSheet( "widget-pickerwheel-standard.png", options )

	-- Create the widget
	pickerWheel = widget.newPickerWheel(
	    {
	        columns = columnData,
	        sheet = pickerWheelSheet,
	        overlayFrame = 1,
	        overlayFrameWidth = 320,
	        overlayFrameHeight = 222,
	        backgroundFrame = 2,
	        backgroundFrameWidth = 320,
	        backgroundFrameHeight = 222,
	        columnColor = { 0, 0, 0, 0 },
	        fontColor = { 1, 1, 1, 0.5 },
	        fontColorSelected = { 0.2, 0.6, 0.4 }
	    }
	)
	pickerWheel.x, pickerWheel.y = display.contentCenterX, display.contentCenterY

	playBtn = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Play Now!",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = onPlayBtnRelease
	}
	playBtn.x, playBtn.y = display.contentCenterX, display.contentCenterY+135

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( betText )
	sceneGroup:insert( pickerWheel )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene 