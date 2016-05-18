-----------------------------------------------------------------------------------------
--
-- bjtable.lua
--
-----------------------------------------------------------------------------------------
-- Require the widget library
local widget = require( "widget" )

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-- display text status
local t = display.newText( "Let's Play BlackJack!", 0, 0, native.systemFont, 18 )
t.x, t.y = display.contentCenterX, 70

-- make a card
local card = display.newImageRect( "jack_of_spades.png", 90, 90 )
card.x, card.y = display.contentCenterX, display.contentCenterY
card.rotation = 15
card.isVisible = false

-- These are the functions triggered by the buttons
local button1Press = function( event )
	t.text = "Displayed Card"
	card.isVisible = true
end

local button1Release = function( event )
	t.text = "Hid Card"
	card.isVisible = false
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "Table_Green_banner.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	-- display status
	local roundedRect = display.newRoundedRect( 10, 50, 300, 40, 8 )
	roundedRect.x, roundedRect.y = display.contentCenterX, 70 	-- simulate TopLeft alignment
	roundedRect:setFillColor( 0/255, 0/255, 0/255, 170/255 )

	local stickbutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Stick",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onPress = button1Press,
		onRelease = button1Release,
	}
	stickbutton.x, stickbutton.y = display.contentCenterX-150, display.contentCenterY+120

	local hitbutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Hit",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onPress = button1Press,
		onRelease = button1Release,
	}
	hitbutton.x, hitbutton.y = display.contentCenterX, display.contentCenterY+120

	local doublebutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Double",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onPress = button1Press,
		onRelease = button1Release,
	}
	doublebutton.x, doublebutton.y = display.contentCenterX+150, display.contentCenterY+120

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( hitbutton )
	sceneGroup:insert( stickbutton )
	sceneGroup:insert( doublebutton )
	sceneGroup:insert( card )
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

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene