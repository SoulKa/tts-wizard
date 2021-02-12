-- GLOBAL VARIABLES --
GameVariants = { "None", "PlusMinusOne", "HiddenBid" }
CardProperties = {} -- contains the values and colors of the cards (mapped to their guid)
Deck = {}
CardColors = {"green", "red", "blue", "yellow"}
IS_DEBUG = false

-- the current state of the game
GameState = {
    Players = {},               -- { string player }
    Round = 0,
    PlayedCards = {},           -- { { string player, string color, int value, string guid } }
    HandCards = {},             -- { string player = { string guid } }
    CurrentPlayer = 1,
    CurrentDealer = 1,
    TrumpColor = "white",
    Tricks = {},                -- { string player = int trickAmount }
    TrickCount = 0,             -- the amount of tricks done in this round
    Bets = {},                  -- { string player = int amount }
    BetCount = 0,               -- the amount of bets done in this round
    BetSum = 0,                 -- the sum of all bets in this round,
    Scores = {},                -- { string player = int points }
    Dealing = false,            -- true if the game is currently dealing cards (for around 1 sec)
    Settings = {
        Variant=GameVariants[1] -- one of GameVariants
    }
}

PlayerObjects = {}              -- { string player = { Table = object tableObject, Counter = Counter counterObject } }
Rules = {}                      -- The game object with the rules on it
CardsInGame = {}                -- { object card }
Locale = {
    CurrentLocale = "en",
    en = {
        start = || "START",
        startsTheGame = || "Starts the game",
        notAllPlayersHaveMadeTheirBetYet = || "Not all players have made their bet yet!",
        itsNotYourTurnToPlay = |name| "It's not your turn to play " .. name .. "!",
        endRound = || "END ROUND",
        endsTheCurrentRound = || "Ends the current round",
        playerIsTheDealer = |name| name .. " is the dealer!",
        dealTheCardsToThePlayers = || "Deal the cards to the players",
        deal = || "DEAL",
        roundXStarts = |round| "Round " .. round .. " starts...",
        playerNameWonTheTrick = |name| name .. " won the trick!",
        roundXEnds = |round| "Round " .. round .. " ends...",
        colorIsTrump = |color| color .. " is trump!",
        betOnXTricks = |i| "Bet on " .. i .. " trick" .. (i==1 and "" or "s"),
        playerBetsAmount = |name, amount| name .. " bets on " .. amount .. " trick" .. (amount==1 and "" or "s"),
        itsPlayersTurn = |name| "It's " .. name .. "'" .. (string.sub(name, -1) == "s" and "" or "s") .. " turn!",
        youAreNotTheDealer = || "You are not the dealer!",
        theDeckIsIncomplete = || "The deck is incomplete! It must contain 60 cards!",
        placeNameAndScore = |place, name, score| place .. ". place: " .. name .. " with " .. score .. " points",
        scores = || "================== SCORES ==================",
        white = || "White",
        red = || "Red",
        yellow = || "Yellow",
        green = || "Green",
        blue = || "Blue",
        selectsColorAsTrump = |color| "Select " .. string.lower(color) .. " as trump color",
        gameOver = || "The game is over!",
        youMustFollowSuit = |color| "You must follow suit!",
        notYourHandCard = || "That's not a hand card of yours!",
        scoreboardButtonTooltip = |isOpen| (isOpen and "Closes" or "Opens") .. " the scoreboard",
        adminPanelButtonTooltip = |isOpen| (isOpen and "Closes" or "Opens") .. " the admin panel",
        roundAlreadyStarted = || "The round has already started! You cannot change the game variant once the game has staret",
        gameVariantIsNow = |variant, isActive| ("The game variant is now \"" .. ((Locale[Locale.CurrentLocale].Variants[variant])()) .. "\""),
        Variants = {
            None = || "Classic",
            PlusMinusOne = || "Plus/minus one",
            HiddenBid = || "Hidden bid"
        },
        languageIsNow = || "The mod language is now English"
    },
    de = {
        start = || "START",
        startsTheGame = || "Startet das Spiel",
        notAllPlayersHaveMadeTheirBetYet = || "Es wurden noch nicht alle Stiche angesagt!",
        itsNotYourTurnToPlay = |name| "Du bist noch nicht dran " .. name .. "!",
        endRound = || "RUNDE BEENDEN",
        endsTheCurrentRound = || "Beendet die aktuelle Runde",
        playerIsTheDealer = |name| name .. " ist der Dealer!",
        dealTheCardsToThePlayers = || "Karten austeilen",
        deal = || "DEALEN",
        roundXStarts = |round| "Runde " .. round .. " beginnt...",
        playerNameWonTheTrick = |name| name .. " holt den Stich!",
        roundXEnds = |round| "Runde " .. round .. " endet...",
        colorIsTrump = |color| color .. " ist Trumpf!",
        betOnXTricks = |amount| amount .. " Stich" .. (amount==1 and "" or "e") .. " ansagen",
        playerBetsAmount = |name, amount| name .. " sagt " .. amount .. " Stich" .. (amount==1 and "" or "e") .. " an",
        itsPlayersTurn = |name| name .. " ist an der Reihe!",
        youAreNotTheDealer = || "Du bist nicht der Dealer!",
        theDeckIsIncomplete = || "Das Deck ist nicht vollständig! Es muss 60 Karten enthalten!",
        placeNameAndScore = |place, name, score| place .. ". Platz: " .. name .. " mit " .. score .. " Punkten",
        scores = || "================== RANGLISTE ==================",
        white = || "Weiß",
        red = || "Rot",
        yellow = || "Gelb",
        green = || "Grün",
        blue = || "Blau",
        selectsColorAsTrump = |color| color .. " als Trumpf bestimmen",
        gameOver = || "Das Spiel ist vorbei!",
        youMustFollowSuit = |color| "Du musst " .. color .. " bedienen!",
        notYourHandCard = || "Das ist keine von deinen Handkarten!",
        scoreboardButtonTooltip = |isOpen| (isOpen and "Schließt" or "Öffnet") .. " das Scoreboard",
        adminPanelButtonTooltip = |isOpen| (isOpen and "Schließt" or "Öffnet") .. " das Admin Panel",
        roundAlreadyStarted = || "Die Runde hat bereits angefangen! Man kann die Spielvariante nicht wechseln während das Spiel läuft",
        gameVariantIsNow = |variant, isActive| ("Die Spielvariante ist jetzt \"" .. ((Locale[Locale.CurrentLocale].Variants[variant])()) .. "\""),
        Variants = {
            None = || "Standard",
            PlusMinusOne = || "Plus/minus Eins",
            HiddenBid = || "Versteckter Tip"
        },
        languageIsNow = || "Die Spielsprache ist jetzt auf Deutsch"
    },
    fr = {
        start = || "DÉPART",
        startsTheGame = || "Départs le jeu",
        notAllPlayersHaveMadeTheirBetYet = || "Il manque enocore des plis!",
        itsNotYourTurnToPlay = |name| "Ce n'est pas encore à toi " .. name .. "!",
        endRound = || "FINIR LA PARTIE",
        endsTheCurrentRound = || "Finit la partie actuelle",
        playerIsTheDealer = |name| name .. " est le dealeur!",
        dealTheCardsToThePlayers = || "Faire la donne",
        deal = || "DEALER",
        roundXStarts = |round| "Le " .. round .. " manche commence...",
        playerNameWonTheTrick = |name| name .. " gagne le pli!",
        roundXEnds = |round| "Le " .. round .. " manche se termine...",
        colorIsTrump = |color| color .. " est l'atout!",
        betOnXTricks = |amount| "Annonce " .. (amount == 0 and "pas de pli" or (amount == 1 and "un seule pli" or (amount .. " plis"))),
        playerBetsAmount = |name, amount| name .. " announce " .. amount .. " pli" .. (amount==1 and "" or "s"),
        itsPlayersTurn = |name| "C'est à " .. name .. "!",
        youAreNotTheDealer = || "Ce n'est pas toi, le dealeur!",
        theDeckIsIncomplete = || "Le jeu de cartes n'est pas complet! Il faut avoir 60 cartes!",
        placeNameAndScore = |place, name, score| place .. ". place: " .. name .. " à " .. score .. " points",
        scores = || "================== Tableau d'avancement ==================",
        white = || "Blanc",
        red = || "Rouge",
        yellow = || "Jaune",
        green = || "Vert",
        blue = || "Bleu",
        selectsColorAsTrump = |color| "Assigner le " .. color .. " comme l'atout",
        gameOver = || "Le jeu est finit!",
        youMustFollowSuit = |color| "Il faut que tu poses le " .. color .. "!",
        notYourHandCard = || "Ce n'est pas un de tes cartes!",
        scoreboardButtonTooltip = |isOpen| (isOpen and "Fermer" or "Ouvrir") .. " le tableau d'avancement",
        adminPanelButtonTooltip = |isOpen| (isOpen and "Fermer" or "Ouvrir") .. " le cadrage",
        roundAlreadyStarted = || "La partie a déja commencé! On peut pas changer la version de jeu pendant le jeu se déroule",
        gameVariantIsNow = |variant, isActive| ("La version du jeu est \"" .. ((Locale[Locale.CurrentLocale].Variants[variant])()) .. "\""),
        Variants = {
            None = || "Standard",
            PlusMinusOne = || "Notequal",
            HiddenBid = || "Pli cachée"
        },
        languageIsNow = || "La langue du jeu est français"
    }
}

-- TTS FUNCTIONS --
function onload()

    -- initialize the UI
    loadUI()

    -- assign global objects
    Deck = getObjectFromGUID("89203a")
    Rules = getObjectFromGUID("a1a910")
    PlayerObjects.White = { Table=getObjectFromGUID("602016"), Counter=getObjectFromGUID("74b2c6"), DropZone=getObjectFromGUID("77d1f9") }
    PlayerObjects.Red = { Table=getObjectFromGUID("c132d8"), Counter=getObjectFromGUID("b367c9"), DropZone=getObjectFromGUID("2a7290") }
    PlayerObjects.Yellow = { Table=getObjectFromGUID("4a3806"), Counter=getObjectFromGUID("cb30fd"), DropZone=getObjectFromGUID("e7ecbf") }
    PlayerObjects.Green = { Table=getObjectFromGUID("ae0d2d"), Counter=getObjectFromGUID("9b0cf1"), DropZone=getObjectFromGUID("65742a") }
    PlayerObjects.Blue = { Table=getObjectFromGUID("830cc7"), Counter=getObjectFromGUID("47b8f7"), DropZone=getObjectFromGUID("fd700f") }
    PlayerObjects.Purple = { Table=getObjectFromGUID("c9413d"), Counter=getObjectFromGUID("f0ea4f"), DropZone=getObjectFromGUID("778448") }

    -- assign values to the according cards
    setCardValues()

    -- create start button
    Rules.createButton({
        click_function = "onGameStart",
        function_owner = self,
        label          = Locale[Locale.CurrentLocale].start(),
        position       = { -1, 0, -2},
        width          = 1000,
        height         = 300,
        tooltip        = Locale[Locale.CurrentLocale].startsTheGame()
    })

end



-- CUSTOM FUNCTIONS --

-- starts the main game
function onGameStart()

    -- prepare game state
    GameState.Players = filter(Player.getAvailableColors(), |player| arrayContains(getSeatedPlayers(), player) )
    GameState.Round = 1
    resetTrickCount()

    -- prepare the score board and points
    for i,player in ipairs(GameState.Players) do writeInCell(0, i, Player[player].steam_name); GameState.Scores[player] = 0 end

    -- spawn the deal button
    Rules.removeButton(0)
    spawnButtons()

end

-- iterates over all cards in the deck and saves the values of them mapped to their guid
function setCardValues()
    for i, cardInfo in ipairs(Deck.getObjects()) do
        local cardProperties = { color = "white", value = 0, sortingValue = 0 }
        if (i < 9) then
            cardProperties.color = "white"
            cardProperties.value = i < 5 and 0 or 14
        else
            cardProperties.color = CardColors[math.floor((i-9)/13)+1]
            cardProperties.value = (i-9) % 13 + 1
        end
        cardProperties.sortingValue = ((i > 4 and i < 9) and (i+56) or i)
        CardProperties[cardInfo.guid] = cardProperties
    end
end

-- spawns buttons in the four card colors so the dealer can pick the trump color
function spawnSelectTrumpColorButtons()
    for i, color in ipairs(CardColors) do
        local upperCaseColor = Locale.en[color]()
        PlayerObjects[GameState.Players[GameState.CurrentDealer]].Table.createButton({
            click_function = "onSelectTrumpColor" .. upperCaseColor,
            position       = { -9 + i * 3.6, 0.6, 0},
            width          = 1000,
            height         = 3000,
            color          = stringColorToRGB(upperCaseColor),
            tooltip        = Locale[Locale.CurrentLocale].selectsColorAsTrump(Locale[Locale.CurrentLocale][color]()),
        })
    end
end

function onSelectTrumpColorGreen(_, pressedByColor) onSelectTrumpColor(pressedByColor, "green") end
function onSelectTrumpColorYellow(_, pressedByColor) onSelectTrumpColor(pressedByColor, "yellow") end
function onSelectTrumpColorRed(_, pressedByColor) onSelectTrumpColor(pressedByColor, "red") end
function onSelectTrumpColorBlue(_, pressedByColor) onSelectTrumpColor(pressedByColor, "blue") end

-- sets the trump color to the color that the dealer selected
function onSelectTrumpColor(pressedByColor, trumpColor)
    local dealerColor = GameState.Players[GameState.CurrentDealer]
    if (dealerColor ~= pressedByColor) then return printToColor(Locale[Locale.CurrentLocale].youAreNotTheDealer(), pressedByColor) end

    -- set trump color
    GameState.TrumpColor = trumpColor
    broadcastToAll(Locale[Locale.CurrentLocale].colorIsTrump(Locale[Locale.CurrentLocale][GameState.TrumpColor]()))

    -- remove buttons
    local dealerTable = PlayerObjects[GameState.Players[GameState.CurrentDealer]].Table
    local buttons = dealerTable.getButtons()
    for i=#buttons,1,-1 do dealerTable.removeButton(buttons[i].index) end

    -- spawn the buttons to bet on the tricks
    initiallySpawnBetTrickButtons()
end

function onObjectEnterScriptingZone(zone, enter_object)
    if (enter_object.type ~= "Card" or GameState.Dealing) then return end

    if (zone.guid == "77d1f9") then return onCardPlayed("White", enter_object) end
    if (zone.guid == "2a7290") then return onCardPlayed("Red", enter_object) end
    if (zone.guid == "e7ecbf") then return onCardPlayed("Yellow", enter_object) end
    if (zone.guid == "65742a") then return onCardPlayed("Green", enter_object) end
    if (zone.guid == "fd700f") then return onCardPlayed("Blue", enter_object) end
    if (zone.guid == "778448") then return onCardPlayed("Purple", enter_object) end
end

-- gets called when an object is dropped. (player: string, card: object) => void
function onCardPlayed(player, card)

    -- check if the player exists and the played object is a card
    if (getIndexOfPlayer(player) == -1) then return end
    local cardProperties = getCardProperties(card.guid)
    if (cardProperties == nil) then return end

     -- run legal checks
    local errorMessage = nil
    local handCardIndex = indexOf(GameState.HandCards[player], card.guid)
    local colorToServe = getColorToServe()
    if (player ~= getCurrentPlayerColor()) then -- check if it's the players turn
        local playedCardOfPlayer = find(GameState.PlayedCards, |c| c.player == player)
        if (playedCardOfPlayer ~= nil and playedCardOfPlayer.guid == card.guid) then return end -- this card was just moved and not played again :)
        errorMessage = Locale[Locale.CurrentLocale].itsNotYourTurnToPlay(Player[player].steam_name)
    elseif (not allBetsDone()) then -- check if everyone made a bet
        errorMessage = Locale[Locale.CurrentLocale].notAllPlayersHaveMadeTheirBetYet()
    elseif (handCardIndex == nil) then -- check if the played card is a hand card of the player
        broadcastToColor(Locale[Locale.CurrentLocale].notYourHandCard(), player, {1,0,0})
        return
    elseif (colorToServe ~= "white" and cardProperties.color ~= "white" and cardProperties.color ~= colorToServe and find(GameState.HandCards[player], |c| getCardProperties(c).color == colorToServe) ~= nil) then -- check if the correct color was served
        errorMessage = Locale[Locale.CurrentLocale].youMustFollowSuit(Locale[Locale.CurrentLocale][colorToServe]())
    end

    -- if any rule was violated => print info to the player and give him the card back
    if (errorMessage ~= nil) then
        broadcastToColor(errorMessage, player, {1,0,0})
        card.deal(1, player)
        return
    end

    -- add card to played cards and remove it from the hand cards of the player
    table.insert(GameState.PlayedCards, { player=player, color=cardProperties.color, value=cardProperties.value, guid=table.remove(GameState.HandCards[player], handCardIndex) })
    card.setLock(true)

    -- next turn or end of round
    if (#GameState.PlayedCards < #GameState.Players) then
        nextTurn()
    else
        onTrickEnd()
    end

end

-- writes the given text into the cell in the score board
function writeInCell( row, col, text, writeInTrick, color )

    -- write into the scoreboard UI
    local uiElementId = (row == 0 and ("sb-table-p" .. tostring(col) .. "-name") or (writeInTrick and ("sb-table-trick-p" .. tostring(col) .. "-r"  .. tostring(row)) or ("sb-table-score-p" .. tostring(col) .. "-r"  .. tostring(row))))
    UI.setAttribute(uiElementId, "text", text)

    -- write onto the scores on the table
    local x = 25.34 + (col-1) * 2.99 + (writeInTrick and 1.5 or 0) + (row == 0 and 0.49 or 0)
    local z = -2.375 - (row-1) * 1.149 + (row == 0 and 0.1 or 0)
    local textObj = spawnObject({ type = "3DText", position = { x, 1, z }, rotation = { 90, 0, 0 } })
    textObj.TextTool.setFontColor(color or { 0, 0, 0 })
    textObj.TextTool.setFontSize(row == 0 and 40 or 60)
    textObj.TextTool.setValue(text)--string.sub(text, 1, 10)
    textObj.reload()
    return textObj

end

-- create the buttons for the game
function spawnButtons()
    if (isLastTrick()) then
        Rules.createButton({
            click_function = "onRoundEnd",
            function_owner = self,
            label          = Locale[Locale.CurrentLocale].endRound(),
            position       = { -1, 0, -2},
            width          = 1000,
            height         = 300,
            tooltip        = Locale[Locale.CurrentLocale].endsTheCurrentRound()
        })
    else
        broadcastToAll(Locale[Locale.CurrentLocale].playerIsTheDealer( Player[GameState.Players[GameState.CurrentDealer]].steam_name ))
        Rules.createButton({
            click_function = "onDealPressed",
            function_owner = self,
            label          = Locale[Locale.CurrentLocale].deal(),
            position       = { -1, 0, -2},
            width          = 1000,
            height         = 300,
            tooltip        = Locale[Locale.CurrentLocale].dealTheCardsToThePlayers()
        })
    end

end

-- returns the values of a card (eg. color="red" and value="1")
function getCardProperties( guid )
    return CardProperties[guid]
end

-- ends the main game
function onGameEnd()
    broadcastToAll(Locale[Locale.CurrentLocale].gameOver())
    printGameStats()
end

-- prints the current ranking of the players into the chat
function printGameStats()
    local color = {128/255, 212/255, 1}
    local scoresHeaderString = Locale[Locale.CurrentLocale].scores()
    printToAll(scoresHeaderString, color)
    for place, playerAndScore in ipairs( table.sort(createPairs(GameState.Scores), |a,b| a[2] > b[2]) ) do
        printToAll(Locale[Locale.CurrentLocale].placeNameAndScore(place, Player[playerAndScore[1]].steam_name, playerAndScore[2]), color)
        place = place+1
    end
    printToAll(string.rep("=", string.len(scoresHeaderString)), color)
end

-- starts the next round
function onDealPressed(_, player, wasRightClick)

    -- check if the dealer clicked the dealing button and that the deck is complete
    if (player ~= GameState.Players[GameState.CurrentDealer]) then return broadcastToColor(Locale[Locale.CurrentLocale].youAreNotTheDealer(), player, {1,0,0}) end
    if (#Deck.getObjects() ~= 60) then return broadcastToColor(Locale[Locale.CurrentLocale].theDeckIsIncomplete(), player, {1,0,0}) end

    -- start the round and deal
    broadcastToAll(Locale[Locale.CurrentLocale].roundXStarts(GameState.Round))
    Rules.removeButton(0)

    -- spawn the buttons to make a bet on the tricks if the trump is not a wizard
    if (deal()) then initiallySpawnBetTrickButtons() end
end

-- ends a running trick
function onTrickEnd()

    -- determine the winner
    local winner = GameState.PlayedCards[1]
    for _, card in ipairs(GameState.PlayedCards) do
        if (
            (winner.value ~= 14) and
            (
                (card.color == winner.color and card.value > winner.value) or -- same color but higher value
                (card.color == GameState.TrumpColor and GameState.TrumpColor ~= "white" and winner.color ~= GameState.TrumpColor) or -- is trump but current strongest card is not
                (card.value == 14 or (winner.value == 0 and card.value ~= 0)) -- is wizard or current strongest card is joker
            )
        ) then winner = card end
    end
    broadcastToAll(Locale[Locale.CurrentLocale].playerNameWonTheTrick(Player[winner.player].steam_name))

    -- move cards to winner
    GameState.Dealing = true
    local container = group( map(GameState.PlayedCards, |card| getObjectFromGUID(card.guid)) )[1]
    table.insert(CardsInGame, #CardsInGame+1, container)
    Wait.time(
        function()
            container.setPositionSmooth(PlayerObjects[winner.player].Table.positionToWorld({0, 5, 0}), false, false)
            container.setRotationSmooth({ 180, 0, 0 }, false, false)
            Wait.time( function() GameState.Dealing = false; end, 1 )
        end
    , 2 )

    -- adjust game state
    GameState.PlayedCards = {}
    GameState.TrickCount = GameState.TrickCount+1
    GameState.Tricks[winner.player] = GameState.Tricks[winner.player]+1
    setCurrentPlayer(winner.player)
    PlayerObjects[winner.player].Counter.setValue(GameState.Tricks[winner.player])

    -- check if the round is over
    if (isLastTrick()) then spawnButtons() end

end

-- ends a running round
function onRoundEnd()

    Rules.removeButton(0)
    broadcastToAll(Locale[Locale.CurrentLocale].roundXEnds(GameState.Round))

    -- calculate scores
    for i, player in ipairs(GameState.Players) do
        local diff = math.abs(GameState.Bets[player] - GameState.Tricks[player])
        GameState.Scores[player] = GameState.Scores[player] + (diff == 0 and 20+GameState.Tricks[player]*10 or -diff*10)
        writeInCell(GameState.Round, i, tostring(GameState.Scores[player]))
    end
    printGameStats()

    -- check if it was the last round
    if (isLastRound()) then return onGameEnd() end

    -- adjust game state
    GameState.Round = GameState.Round+1
    GameState.CurrentDealer = ((GameState.CurrentDealer % #GameState.Players) + 1)
    setCurrentPlayer(GameState.CurrentDealer)
    resetBetCount()
    resetTrickCount()
    spawnButtons()

    -- move cards back in the deck
    GameState.Dealing = true
    for _, card in ipairs(CardsInGame) do Deck.putObject(card) end
    CardsInGame = {}
    Wait.time(function() GameState.Dealing = false end, 1)

end

-- determines if the current round is the last one
function isLastRound()
    return GameState.Round >= math.floor(60 / #GameState.Players)
end

-- returns true if the current trick was the last one
function isLastTrick()
    return GameState.TrickCount >= GameState.Round
end

-- shuffles the deck and deals the cards to the players. Returns true if a trump color was selected and false if a player has to select it
function deal()

    -- shuffle the deck
    GameState.Dealing = true
    Deck.shuffle()

    -- a list of guids that belong to the cards in the deck
    local cards = map(Deck.getObjects(), |card| card.guid )

    -- draw a trump card if it is not last round
    local trumpColorSet = true
    GameState.TrumpColor = "white"
    if (not isLastRound()) then

        -- deal to the middle
        local trump = Deck.takeObject({ position={0,1,0}, flip=true, guid=table.remove(cards) })
        trump.setTags({ "Trump" })
        table.insert(CardsInGame, trump)

        -- determine color and value, if the card is a wizard let the dealer select trump color
        local cardProperties = getCardProperties(trump.guid)
        if (cardProperties.value == 14) then
            spawnSelectTrumpColorButtons()
            trumpColorSet = false
        else
            GameState.TrumpColor = cardProperties.color
            broadcastToAll(Locale[Locale.CurrentLocale].colorIsTrump(Locale[Locale.CurrentLocale][GameState.TrumpColor]()))
        end

    end

    -- deal cards to players
    for iPlayer, player in ipairs(GameState.Players) do

        -- peak the next cards from the deck to make them sortable
        GameState.HandCards[player] = {}
        for n=1, GameState.Round, 1 do table.insert(GameState.HandCards[player], table.remove(cards)) end

        -- sort the cards
        table.sort( GameState.HandCards[player], cardSortingFunction )

        -- deal the sorted cards
        local dealCard = function(obj) obj.setTags({ player }); obj.use_hands=true; obj.deal(1, player) end
        for iCard, card in ipairs(GameState.HandCards[player]) do
            if (iCard == #GameState.HandCards[player] and iPlayer == #GameState.Players and isLastRound()) then
                dealCard(getObjectFromGUID(card))
            else
                Deck.takeObject({ guid=card, smooth=false, callback_function=dealCard })
            end
        end

    end
    Wait.time(function() GameState.Dealing = false end, 1)

    -- true if a trump color was selected and false if a player has to select it
    return trumpColorSet

end

-- returns the player color who's turn it is
function getCurrentPlayerColor()
    return GameState.Players[GameState.CurrentPlayer]
end

-- returns the player who's turn it is
function getCurrentPlayer()
    return Player[getCurrentPlayerColor()]
end

-- returns the index of a player in the game state player array by its color string
function getIndexOfPlayer( player )
    local i
    for i, color in ipairs(GameState.Players) do
        if (color == player) then return i end
    end
    return -1
end

-- returns the card color that has to be played in the current trick. Returns white if any can be played
function getColorToServe()
    for _, card in ipairs(GameState.PlayedCards) do
        if (card.value ~= 0) then return card.color end -- return the first played color of the card that is not a joker
    end
    return "white" -- white means any color can be played
end

-- sets the trick counts for every player and the round to 0
function resetTrickCount()
    GameState.TrickCount = 0
    for _, player in pairs(GameState.Players) do
        GameState.Tricks[player] = 0
        PlayerObjects[player].Counter.setValue(0)
    end
end

-- sets the bet count and sum to 0 and resets the bet table
function resetBetCount()
    GameState.Bets = {}
    GameState.BetCount = 0
    GameState.BetSum = 0
end

-- shows the bet trick buttons depending on the gamemode
function initiallySpawnBetTrickButtons()
    if (GameState.Settings.Variant == "HiddenBid") then
        showBetTrickButtons( GameState.Players )
    else
        showBetTrickButtons( { getCurrentPlayerColor() } )
    end
end

-- shows the bet trick buttons for the given (string) players
function showBetTrickButtons( players, hideNumber )
    if (#players > 0 and IS_DEBUG) then table.insert(players, "Host") end
    local visibility = ""
    for i=0, 20, 1 do
        UI.setAttribute("trick-selection-button"..i, "active", (i > GameState.Round or (type(hideNumber) == "number" and i == hideNumber)) and "false" or "true")
    end
    for i, player in ipairs(players) do
        if (i > 1) then visibility = visibility .. "|" end
        visibility = visibility .. player
    end
    --print("Showing the bet buttons to " .. visibility)
    UI.setAttributes("trick-selection", { visibility=visibility, active=((#players == 0) and "false" or "true") })
end

-- bets the given amount of tricks for the current player
function betTrick(player, amount)
    local playerName = player.steam_name
    player = player.color
    local playerIndex = getIndexOfPlayer(player)
    if (GameState.Bets[player] ~= nil or playerIndex < 1) then
        print("Player \"" .. player .."\" already bet!")
        return
    end

    -- modify game state
    GameState.BetSum = GameState.BetSum+amount
    GameState.BetCount = GameState.BetCount+1
    GameState.Bets[player] = amount

    -- check the game mode/variant
    local playersToShowBetTricksButtons = {}
    if (GameState.Settings.Variant == "HiddenBid") then
        if (GameState.BetCount == #GameState.Players) then
            for player, amount in pairs(GameState.Bets) do
                playerIndex = getIndexOfPlayer(player)
                if (playerIndex > 0) then writeInCell(GameState.Round, playerIndex, tostring(amount), true) end
                printToAll(Locale[Locale.CurrentLocale].playerBetsAmount(player, amount))
            end
        else
            playersToShowBetTricksButtons = filter(GameState.Players, | p | GameState.Bets[p] == nil )
        end
    else
        writeInCell(GameState.Round, playerIndex, tostring(amount), true)
        printToAll(Locale[Locale.CurrentLocale].playerBetsAmount(playerName, amount))
        nextTurn()
        if (not allBetsDone()) then table.insert(playersToShowBetTricksButtons, getCurrentPlayerColor()) end
    end

    -- show the buttons to the correct player(s) and maybe hide one button to prevent equal bids
    showBetTrickButtons( playersToShowBetTricksButtons, (GameState.Settings.Variant == "PlusMinusOne" and GameState.BetCount == (#GameState.Players-1)) and (GameState.Round - GameState.BetSum) or nil )
end

-- returns true if all bets are done
function allBetsDone()
    return GameState.BetCount >= #GameState.Players
end

-- changes the current player to the next one
function nextTurn()
    setCurrentPlayer((GameState.CurrentPlayer % #GameState.Players) + 1)
    printToAll(Locale[Locale.CurrentLocale].itsPlayersTurn(getCurrentPlayer().steam_name))
end

-- function that takes to guids and compares the card values (for sorting)
function cardSortingFunction(guidA, guidB)
    local a = getCardProperties(guidA)
    local b = getCardProperties(guidB)
    if (a.color ~= b.color and GameState.TrumpColor ~= "white" and a.color ~= "white" and b.color ~= "white") then
        if (a.color == GameState.TrumpColor) then return false end
        if (b.color == GameState.TrumpColor) then return true end
    end
    return (b.sortingValue > a.sortingValue)
end

-- changes the current player to the given one. This can either be the player index or the player color
function setCurrentPlayer( player )
    local index = (type(player) == "number" and player or getIndexOfPlayer(player))
    if (index == nil or index < 1 or index > #GameState.Players) then
        print("Tried to set an invalid value as current player: " .. tostring(player))
    else
        GameState.CurrentPlayer = index
        Turns.turn_color = GameState.Players[index]
    end
end



-- HELPER FUNCTIONS
-- generic map function
function map( tbl, f )
    local t = {}
    for k,v in pairs(tbl) do t[k] = f(v) end
    return t
end

function filter( arr, f )
    local res = {}
    for _,v in ipairs(arr) do if (f(v)) then table.insert(res, v) end end
    return res
end

function arrayContains( arr, v )
    for _, v2 in ipairs(arr) do
        if (v2 == v) then return true end
    end
    return false
end

-- generic find function for tables. The callback f must return true if the searched item was found
function find( tbl, f )
    for _, v in pairs(tbl) do if (f(v)) then return v end end
    return nil
end

function indexOf( tbl, v )
    for k, v2 in pairs(tbl) do
        if (v2 == v) then return k end
    end
    return nil
end

function createPairs( tbl )
    local t = {}
    for k,v in pairs(tbl) do table.insert(t, { k,v }) end
    return t
end

function reverse( t )
    local n = #t
    local i = 1
    while i < n do
        t[i],t[n] = t[n],t[i]
        i = i + 1
        n = n - 1
    end
end

function stringSplit( str, sep )
    t = {}
    for _, v in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(t, v)
    end
    return t
end





-- UI FUNCTIONS
function loadUI()

end

-- player the initiated this function call, the name of the game variant, the id of the checkbox to set
function onSetGameVariant( player, variant, id )
    if (GameState.Round > 0) then
        broadcastToColor(Locale[Locale.CurrentLocale].roundAlreadyStarted(), player.color, { 1, 0, 0 })
    else
        if (not arrayContains(GameVariants, variant)) then
            print("The selected game variant \"" .. tostring(variant) .. "\" is invalid!")
            return
        end

        GameState.Settings.Variant = variant
        broadcastToAll(Locale[Locale.CurrentLocale].gameVariantIsNow(GameState.Settings.Variant))
    end
end

function onScoreboardToggle()
    local isOpen = (UI.getAttribute("scoreboard", "active") == "true")
    UI.setAttribute("scoreboard", "active", tostring(not isOpen))
    UI.setAttribute("scoreboard-button", "tooltip", Locale[Locale.CurrentLocale].scoreboardButtonTooltip(not isOpen))
end

function onAdminPanelToggle()
    local isOpen = (UI.getAttribute("admin-panel", "active") == "true")
    UI.setAttribute("admin-panel", "active", tostring(not isOpen))
    UI.setAttribute("admin-panel-button", "tooltip", Locale[Locale.CurrentLocale].adminPanelButtonTooltip(not isOpen))
end

function onTabButtonPressed( _, __, id )
    setCurrentSettingsTab( tonumber(id:sub(-1)) ) -- admin-panel-button-tab1 => "1"
end

function onSelectLanguage( player, language )
    if (language == "German") then
        Locale.CurrentLocale = "de"
    elseif (language == "English") then
        Locale.CurrentLocale = "en"
    elseif (language == "French") then
        Locale.CurrentLocale = "fr"
    else
        broadcastToColor("For some reason your selected language is not defined...", player.color, { 1, 0, 0 })
        return
    end
    broadcastToAll(Locale[Locale.CurrentLocale].languageIsNow())
end

function onBetTrick( player, amount )
    amount = tonumber(amount)
    if (amount == nil or amount < 0 or amount > 20) then
        printToColor("Invalid trick amount: " .. amount, player)
        return
    end
    betTrick(player, amount)
end