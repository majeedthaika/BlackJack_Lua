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
-- Local Variables
local background;
local roundedRect;
local t;
local stickbutton;
local hitbutton;
local doublebutton; 
local suits = {"h","d","c","s"}; -- hearts = h,diamonds =d,clubs =c,spades=s
local deck; -- The deck of Cards
local playerHand = {}; -- a table to hold the players cards
local dealerHand = {}; -- a table to hold the dealers cards
local allCards = {} -- a table to hold all cards
local betAmount = 0; -- how much the player is betting Total
local money; -- how much money the player has
local blackJack = false; -- whether player or dealer has blackjack
local firstDealerCard = ""; -- a reference to the first card the dealer is dealt
local playerYields = false; -- whether or not the player has stood on his hand
local winner=""; -- who the winner of the round is
local bet=0; -- how much the player is adding to betAmount variable
local bankText; -- shows the players money
local betText; -- shows how much the player is betting

--------------------------------------------

-- NewGame Setup functions

function Setup()
	setupButtons()
	setupTextFields()
	addListeners()
	createDeck()
end

function setupButtons()
	-- display action buttons
	stickbutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Stick",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	stickbutton.x, stickbutton.y = display.contentCenterX-150, display.contentCenterY+120

	hitbutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Hit",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	hitbutton.x, hitbutton.y = display.contentCenterX, display.contentCenterY+120

	doublebutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Double",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	doublebutton.x, doublebutton.y = display.contentCenterX+150, display.contentCenterY+120
end

function setupTextFields()
	-- display text status
	t = display.newText( "Let's Play BlackJack!", 0, 0, native.systemFont, 18 )
	t.x, t.y = display.contentCenterX, 70
	t:setFillColor( 1, 1, 1 )
end

function addListeners()
	stickbutton:addEventListener('touch',stick)
	hitbutton:addEventListener('touch',hit)
	doublebutton:addEventListener('touch',double)
end

function stick()
	
end

function hit()
	
end

function double()
	
end

function createDeck()
	deck = {};
	for i=1,4 do
		for j=1,13 do
			local tempCard = suits[i]..j;
			table.insert(deck,tempCard);
		end
	end
end

Setup()
--------------------------------------------

-- make a card
local card = display.newImageRect( "Js.png", 90, 90 )
card.x, card.y = display.contentCenterX, display.contentCenterY
card.isVisible = false

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- create background
	background = display.newImageRect( "Table_Green_banner.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	-- display status
	roundedRect = display.newRoundedRect( 10, 50, 300, 40, 8 )
	roundedRect.x, roundedRect.y = display.contentCenterX, 70 	-- simulate TopLeft alignment
	roundedRect:setFillColor( 0/255, 0/255, 0/255, 170/255 )

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( roundedRect )
	sceneGroup:insert( t )
	sceneGroup:insert( hitbutton )
	sceneGroup:insert( stickbutton )
	sceneGroup:insert( doublebutton )
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