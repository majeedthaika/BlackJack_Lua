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
-- Global Variables

local bankVal; -- the players money
local betVal; -- how much the player is betting

--------------------------------------------
-- Local Variables
local background; -- Poker table background
local roundedRect; -- Status field rectangle
local t; -- Status text
local dealbutton; -- Deal action button
local standbutton; -- Stand action button
local hitbutton; -- Hit action button
local doublebutton; -- Double action button
local continuebutton; -- Continue action button
local playagainbutton; -- Play again action button
local menupagebutton; -- Play again action button
local suits = {"h","d","c","s"}; -- hearts = h,diamonds =d,clubs =c,spades=s
local deck; -- The deck of Cards
local playerHand = {}; -- a table to hold the players cards
local playerHandDisplay = {}; -- a table to hold the players cards file
local dealerHand = {}; -- a table to hold the dealers cards
local dealerHandDisplay = {}; -- a table to hold the dealers cards file
local allCards = {} -- a table to hold all cards
local bankText; -- displays the players money
local betText; -- displays how much the player is betting this round
local playerSum; -- shows the player's points
local dealerSum; -- shows the dealer's points
local moved=false; -- if current button has been moved, set to true
local lastPlayerIdx; -- to calculate offset for placing player's card
local lastDealerIdx; -- to calculate offset for placing dealer's card

--------------------------------------------

-- NewGame Setup functions

function Setup()
	-- Calling all other setup functions
	showBackground()
	showOtherObjects()
	setupButtons()
	addListeners()
	math.randomseed(os.time());
	createDeck()
	setupTextFields()
	dealInitial()
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
	roundedRect = display.newRoundedRect( 10, 50, 400, 40, 8 )
	roundedRect.x, roundedRect.y = display.contentCenterX-25, 80 	-- simulate TopLeft alignment
	roundedRect:setFillColor( 0/255, 0/255, 0/255, 170/255 )
end

function setupButtons()
	-- display action buttons
	standbutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Stand",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	standbutton.x, standbutton.y = display.contentCenterX-180, display.contentCenterY+120

	hitbutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Hit",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	hitbutton.x, hitbutton.y = display.contentCenterX-30, display.contentCenterY+120

	doublebutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Double",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	doublebutton.x, doublebutton.y = display.contentCenterX+120, display.contentCenterY+120

	continuebutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Continue",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	continuebutton.x, continuebutton.y = display.contentCenterX-30, display.contentCenterY+120
	continuebutton.isVisible = false

	playagainbutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Play Again",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	playagainbutton.x, playagainbutton.y = display.contentCenterX-90, display.contentCenterY+120
	playagainbutton.isVisible = false

	menupagebutton = widget.newButton{
		defaultFile = "buttonBlueSmall.png",
		overFile = "buttonBlueSmallOver.png",
		label = "Main Menu",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	}
	menupagebutton.x, menupagebutton.y = display.contentCenterX+60, display.contentCenterY+120
	menupagebutton.isVisible = false
end

function setupTextFields()

	-- display player's bet
	local options = {
	    text = "Bet Amount: $", -- supports up to 11 digits   
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
	    text = "Bank Amount: $", -- supports up to 11 digits      
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
	t = display.newText( "Started new Squikly BlackJack game!", display.contentCenterX-25, 80, native.systemFont, 18 )
	t:setTextColor( 1, 1, 1 )

	-- display player's card sum
	local options = {
	    text = "Player: ",
	    x = display.contentCenterX-150,
	    y = display.contentCenterY+70,
	    width = 150,
	    font = native.systemFontBold,   
	    fontSize = 18,
	    align = "left"  --new alignment parameter
	}
	playerSum = display.newText(options);
    playerSum:setTextColor(1,1,1)

    -- display dealer's card sum
	local options = {
	    text = "Dealer: ", 
	    x = display.contentCenterX+90,
	    y = display.contentCenterY+70,
	    width = 150,
	    font = native.systemFontBold,   
	    fontSize = 18,
	    align = "left"  --new alignment parameter
	}
	dealerSum = display.newText(options);
    dealerSum:setTextColor(1,1,1)
end

function addListeners()
	-- for all button touch events
	standbutton:addEventListener('touch',stand)
	hitbutton:addEventListener('touch',hit)
	doublebutton:addEventListener('touch',double)
	continuebutton:addEventListener('touch',continue)
	playagainbutton:addEventListener('touch',playagain)
	menupagebutton:addEventListener('touch',menupage)
end

function dealInitial()
	-- Deal out starting player+dealer card
	local randIndex = math.random(#deck)
	table.insert(playerHandDisplay, display.newImageRect(deck[randIndex]..".png", 90, 90 ))
	playerHandDisplay[1].x, playerHandDisplay[1].y = display.contentCenterX-180, display.contentCenterY
	table.insert(playerHand,deck[randIndex])
	table.remove(deck,randIndex);
	
	randIndex = math.random(#deck)
	table.insert(playerHandDisplay, display.newImageRect(deck[randIndex]..".png", 90, 90 ))
	playerHandDisplay[2].x, playerHandDisplay[2].y = display.contentCenterX-150, display.contentCenterY
	table.insert(playerHand,deck[randIndex])
	table.remove(deck,randIndex);

	randIndex = math.random(#deck)
	table.insert(dealerHandDisplay, display.newImageRect(deck[randIndex]..".png", 90, 90 ))
	dealerHandDisplay[1].x, dealerHandDisplay[1].y = display.contentCenterX+60, display.contentCenterY
	table.insert(dealerHand,deck[randIndex])
	table.remove(deck,randIndex);

	table.insert(dealerHandDisplay, display.newImageRect("back.png", 90, 90 ))
	dealerHandDisplay[2].x, dealerHandDisplay[2].y = display.contentCenterX+90, display.contentCenterY

	playerSum.text = "Player: "..getHandValue(playerHand).." pts"
	dealerSum.text = "Dealer: "..getHandValue(dealerHand).." pts"

	-- Offset of where to place cards next
	lastPlayerIdx = -120
	lastDealerIdx = 90

	-- Checks for BlackJack
	buttonController()
end

function stand(event)
	if ( event.phase == "began" ) then
        t.text = "Happy with your points?"
        moved = false
    elseif ( event.phase == "moved" ) then
        t.text = ""
        moved = true
    else
    	if ( moved == false ) then
    		t.text = "Stand done"
			playerDone()
    	end
    end
    return true
end

function hit(event)
	if ( event.phase == "began" ) then
        t.text = "Hit me baby one more time!"
        moved = false
    elseif ( event.phase == "moved" ) then
        t.text = ""
        moved = true
    else
    	if ( moved == false ) then
    		t.text = "Hit done"
    		newCardHit()
    	end
    end
    return true
end

function double(event)
	if ( event.phase == "began" ) then
        t.text = "Double or nothing?"
        moved = false
    elseif ( event.phase == "moved" ) then
        t.text = ""
        moved = true
    else
    	if ( moved == false ) then
    		t.text = "Doubled!"
    		bankVal = bankVal - betVal
    		betVal = betVal + betVal

    		betText.text = "Bet Amount: $"..betVal
			bankText.text = "Bank Amount: $"..bankVal
			doublebutton.isVisible = false
    		newCardHit()
    	end
    end
    return true
end

function continue(event)
	if ( event.phase == "began" ) then
        t.text = "Reveal Cards?"
        moved = false
    elseif ( event.phase == "moved" ) then
        t.text = ""
        moved = true
    else
    	if ( moved == false ) then
    		t.text = "Continue done"
			resolveDealer()
    	end
    end
    return true
end

function playagain(event)
	if ( event.phase == "began" ) then
        t.text = "Play New Game?"
        moved = false
    elseif ( event.phase == "moved" ) then
        t.text = ""
        moved = true
    else
    	if ( moved == false ) then
    		-- go to betpage.lua scene
			local options = {
			effect = "fade",
			time = 500,
			params = {bankAmount=bankVal}
			}
			composer.gotoScene( "betpage", options )
    	end
    end
    return true
end

function menupage(event)
	if ( event.phase == "began" ) then
        t.text = "Go back to Main Menu?"
        moved = false
    elseif ( event.phase == "moved" ) then
        t.text = ""
        moved = true
    else
    	if ( moved == false ) then
    		-- go to menu.lua scene
			local options = {
			effect = "fade",
			time = 500,
			params = {bankAmount=bankVal}
			}
			composer.gotoScene( "menu", options )
    	end
    end
    return true
end

function createDeck()
	--Create deck + name it according to card images
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

function getHandValue(theHand)
	-- Calculate current value of the player's/dealer's hand
	local handValue = 0;
	local hasAceInHand=false;
    for i=1,#theHand do
    	local cardsValue = string.sub(theHand[i],1,1);
        if (cardsValue == "A") then
        	cardsValue = 1;
        	hasAceInHand = true;
        elseif cardsValue > "9" then
        	cardsValue = 10
		else
			cardsValue = tonumber(cardsValue)
		end
        handValue = handValue + cardsValue;
        if (cardsValue == 1) then
            hasAceInHand = true;
        end
    end
    if (hasAceInHand and handValue <= 11)then
    	return (handValue+10).." or "..handValue;
    end
    return handValue;
end

function newCardHit()
	-- Event when player clicks "Hit" button
	local randIndex = math.random(#deck)
	table.insert(playerHandDisplay, display.newImageRect(deck[randIndex]..".png", 90, 90 ))
	playerHandDisplay[#playerHandDisplay].x, playerHandDisplay[#playerHandDisplay].y = display.contentCenterX+lastPlayerIdx, display.contentCenterY
	if (lastPlayerIdx < -60) then
		lastPlayerIdx = lastPlayerIdx+30
	end
	table.insert(playerHand,deck[randIndex])
	table.remove(deck,randIndex);

	playerSum.text = "Player: "..getHandValue(playerHand).." pts"
	buttonController()
end

function checkPoints(theHand)
	-- Checks for BlackJack or Busted
	local points = getHandValue(theHand)
	local upperbound = tonumber(string.sub(points,1,2))

	if (upperbound == 21) then
		return "blackjack"
	elseif (upperbound > 21) then
		return "busted"
	else
		return "normal"
	end
end

function winner()
	-- Sees who is the winner based on current points
	local dealerPts = tonumber(string.sub(getHandValue(dealerHand),1,2))
	local playerPts = tonumber(string.sub(getHandValue(playerHand),1,2))

	if (dealerPts == playerPts) then
		return "draw"
	elseif (dealerPts > playerPts) then
		return "dealer"
	else
		return "player"
	end
end

function playerDone()
	hitbutton.isVisible = false
	standbutton.isVisible = false
	doublebutton.isVisible = false
	continuebutton.isVisible = true
end

function calculateWinner(roundWinner)
	if (roundWinner == "dealer") then
		t.text = "Dealer Win"
	elseif (roundWinner == "player") then
		t.text = "Player Win"
		bankVal = bankVal + (2*betVal)
	else
		t.text = "Draw"
		bankVal = bankVal + betVal
	end
	continuebutton.isVisible = false
	playagainbutton.isVisible = true
	menupagebutton.isVisible = true
end

function resolveDealer()
	local resolved = false
	while ( resolved == false ) do
		local upperbound = tonumber(string.sub(getHandValue(dealerHand),1,2))
		if (upperbound > 21) then
			calculateWinner("player")
			resolved = true
		elseif (upperbound >= 17) then
			calculateWinner( winner() )
			resolved = true
		else
			local randIndex = math.random(#deck)
			table.insert(dealerHandDisplay, display.newImageRect(deck[randIndex]..".png", 90, 90 ))
			dealerHandDisplay[#dealerHandDisplay].x, dealerHandDisplay[#dealerHandDisplay].y = display.contentCenterX+lastDealerIdx, display.contentCenterY
			if (lastDealerIdx < 150) then
				lastDealerIdx = lastDealerIdx+30
			end
			table.insert(dealerHand,deck[randIndex])
			table.remove(deck,randIndex);

			dealerSum.text = "Dealer: "..getHandValue(dealerHand).." pts"
		end
	end
end

function buttonController()
	-- Calculates if buttons need to be hidden/shown
	local result = checkPoints(playerHand)

	if (result == "blackjack") then
		t.text = "BlackJack!"
		playerDone()
	elseif (result == "busted") then
		t.text = "Busted!"
		hitbutton.isVisible = false
		standbutton.isVisible = false
		doublebutton.isVisible = false
		playagainbutton.isVisible = true
		menupagebutton.isVisible = true
	end
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
	sceneGroup:insert( standbutton )
	sceneGroup:insert( doublebutton )
	sceneGroup:insert( continuebutton )
	sceneGroup:insert( playagainbutton )
	sceneGroup:insert( menupagebutton )
	sceneGroup:insert( betText )
	sceneGroup:insert( bankText )
	sceneGroup:insert( playerSum )
	sceneGroup:insert( dealerSum )
	sceneGroup:insert( t )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	-- Get params from betpage
	betVal = event.params.betAmount
	bankVal = event.params.bankAmount

	-- Update Amount displays
	betText.text = "Bet Amount: $"..betVal
	bankText.text = "Bank Amount: $"..bankVal

	composer.removeScene( "betpage" )
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.


		-- Getting bet/bank values from betpage

	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase

	for i=1,#playerHandDisplay do
		sceneGroup:insert( playerHandDisplay[i] )
	end

	for i=1,#dealerHandDisplay do
		sceneGroup:insert( dealerHandDisplay[i] )
	end
	
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