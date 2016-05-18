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
local background; -- Poker table background
local roundedRect; -- Status field rectangle
local t; -- Status text
local dealbutton; -- Deal action button
local stickbutton; -- Stick action button
local hitbutton; -- Hit action button
local doublebutton; -- Double action button
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
	bankText = 10000
	showBackground()
	showOtherObjects()
	setupButtons()
	addListeners()
	math.randomseed(os.time());
	createDeck()
	setupTextFields()
	startGame()
end

function showBackground()
	-- create background
	background = display.newImageRect( "Table_Green_banner.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
end

function showOtherObjects()
	-- display status
	roundedRect = display.newRoundedRect( 10, 50, 300, 40, 8 )
	roundedRect.x, roundedRect.y = display.contentCenterX-25, 80 	-- simulate TopLeft alignment
	roundedRect:setFillColor( 0/255, 0/255, 0/255, 170/255 )
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
	-- display player's balance
	local options = {
	    text = "Bet Amount: $1000", -- supports up to 11 digits   
	    x = 100,
	    y = 30,
	    width = 150,
	    font = native.systemFontBold,   
	    fontSize = 18,
	    align = "left"  --new alignment parameter
	}
	betText = display.newText(options);
    betText:setTextColor(0,0,0)

	-- display player's balance
	local options = {
	    text = "Balance: $999999", -- supports up to 11 digits      
	    x = display.contentCenterX+20,
	    y = 30,
	    width = 150,
	    font = native.systemFontBold,   
	    fontSize = 18,
	    align = "left"  --new alignment parameter
	}
	bankText = display.newText(options);
    bankText:setTextColor(0,0,0)

	-- display text status
	t = display.newText( "Let's Play BlackJack!", display.contentCenterX-25, 80, native.systemFont, 18 )
	t:setTextColor( 1, 1, 1 )
end

function addListeners()
	stickbutton:addEventListener('touch',stick)
	hitbutton:addEventListener('touch',hit)
	doublebutton:addEventListener('touch',double)
end

function startGame()
	local randIndex = math.random(#deck)
	print(deck[randIndex]..".png")
	local playerCard1 = display.newImageRect(deck[randIndex]..".png", 90, 90 )
	playerCard1.x, playerCard1.y = display.contentCenterX-150, display.contentCenterY
	table.remove(deck,randIndex);
	

	local randIndex = math.random(#deck)
	print(deck[randIndex]..".png")
	local playerCard2 = display.newImageRect(deck[randIndex]..".png", 90, 90 )
	playerCard2.x, playerCard2.y = display.contentCenterX-125, display.contentCenterY
	table.remove(deck,randIndex);

	local randIndex = math.random(#deck)
	print(deck[randIndex]..".png")
	local dealercard1 = display.newImageRect(deck[randIndex]..".png", 90, 90 )
	dealercard1.x, dealercard1.y = display.contentCenterX+70, display.contentCenterY
	table.remove(deck,randIndex);

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
			local tempCard
			if j == 1 then
				tempCard = "A"..suits[i];
			elseif j == 10 then
				tempCard = "T"..suits[i];
			elseif j == 11 then
				tempCard = "J"..suits[i];
			elseif j == 12 then
				tempCard = "Q"..suits[i];
			elseif j == 13 then
				tempCard = "K"..suits[i];
			else
				tempCard = j..suits[i];
			end
			table.insert(deck,tempCard);
		end
	end
end

-- Calculate current value of the player's/dealer's hand
function getHandValue(theHand)
	local handValue = 0;
	local hasAceInHand=false;
    for i=1,#theHand do
    	local cardsValue =  tonumber(string.sub(theHand[i],2,3));
        if (cardsValue > 10) then
        	cardsValue = 10;
        end
        
        handValue = handValue + cardsValue;
        if (cardsValue == 1) then
            hasAceInHand = true;
        end
    end
    if (hasAceInHand and handValue <= 11)then
    	handValue = handValue + 10;
    end
    return handValue;
end

--------------------------------------------

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	Setup()

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( roundedRect )
	sceneGroup:insert( hitbutton )
	sceneGroup:insert( stickbutton )
	sceneGroup:insert( doublebutton )
	sceneGroup:insert( betText )
	sceneGroup:insert( bankText )
	sceneGroup:insert( t )
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