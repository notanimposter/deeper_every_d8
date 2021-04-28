-- Imports
local lg = love.graphics
local Assets = require 'assets'
local Bachelors = require 'bachelors'
local Locations = require 'locations'
local Interests = require 'interests'
local BachelorSpeech = require 'bachelor_speech'
local hex = (require 'util').hex
local pick = (require 'util').pick
local inrange = (require 'util').inrange
local shuffle = (require 'util').shuffle
-- Global spaghetti
DEBUG = false
function dprint (str) if DEBUG then print (str) end end
HEART_QUADS = {}
HEARTS_MAX = 4
CARDS = {
	revealed = 0
}
HOVERING = {
	type = 'none',
	index = 0
}
RESPONSES = {}
RESPONSE_FORMATS = {
	love = {
		"Wow, that's so interesting",
		"Really? Cool!",
		"I know, right! Fascinating.",
		"I think that's beautiful."
	},
	hate = {
		"I don't know what to make of that.",
		"Oh... ok.",
		"That's... um... anyway...",
		"I'm not sure what that means."
	},
	interests = {
		"I like %s.",
		"I've been into %s recently.",
		"Hm, %s is my true passion."
	}
}

function card_reveal ()
	if CARDS.revealed < #CARDS then
		CARDS.revealed = CARDS.revealed + 1
		Assets.Sounds.card_flip:play ()
	end
end
function bachelor_is_card (bachelor)
	for i,v in ipairs (CARDS) do
		if v == bachelor then
			return true
		end
	end
	return false
end
function heart_down ()
	Bachelors.current.love = math.max (Bachelors.current.love - 0.5, 0)
	Assets.Sounds.oof:play ()
end
function heart_up ()
	local love_was = Bachelors.current.love
	if Bachelors.current.love < HEARTS_MAX then
		Bachelors.current.love = Bachelors.current.love + 0.5
		Assets.Sounds.doki_doki:play ()
	end
	
	if love_was < HEARTS_MAX and Bachelors.current.love >= HEARTS_MAX then
		Bachelors.current.love = 9999
		local not_everyone = false
		for k,v in pairs (Bachelors) do
			if v.love < HEARTS_MAX then
				not_everyone = true
			end
		end
		local cards_done = 0
		for i,v in ipairs (CARDS) do
			if v.love >= HEARTS_MAX then
				cards_done = cards_done + 1
			end
		end
		local special_text = ""
		if cards_done >= #CARDS then
			special_text = "Full house!"
		end
		if not not_everyone then
			special_text = "All 8!"
		end
		local friendzone_or_win = "I know we're going to be friends forever!       "
		if bachelor_is_card (Bachelors.current) then
			friendzone_or_win = "I... love you, $PLAYER_NAME."
			BachelorSpeech.set_callback (function ()
				RESPONSES = {{text="You and "..Bachelors.current.name.." live happily ever after."},{text=special_text},{text="[continue]",click=bachelor_converse}}
			end)
			--local n = CARDS.revealed
			for i=CARDS.revealed,#CARDS do
				if CARDS[i] == Bachelors.current then
					-- we need to reveal the ith card
					if CARDS.revealed ~= #CARDS then
						CARDS[i], CARDS[CARDS.revealed+1] = CARDS[CARDS.revealed+1], CARDS[i]
					end
					card_reveal ()
				end
			end
			--if n == CARDS.revealed then card_reveal () end
		else
			BachelorSpeech.set_callback (function ()
				RESPONSES = {{text="It's just not in the cards for you"},{text="and "..Bachelors.current.name..". "..special_text},{text="[continue]", click=bachelor_converse}}
			end)
			card_reveal () -- reveal a card if this bachelor wasn't one of them
		end
		RESPONSES = {}
		BachelorSpeech.say ("We get along so well... "..friendzone_or_win)
	elseif love_was < HEARTS_MAX/2 and Bachelors.current.love >= HEARTS_MAX/2 then
		RESPONSES = {}
		BachelorSpeech.set_callback (bachelor_converse)
		BachelorSpeech.say ("We should really go somewhere sometime.               ")
	end
end
function bachelor_hello ()
	RESPONSES = {}
	BachelorSpeech.say (pick ({"Hey! Fancy meeting you here.", "What's up?", "Hello there."}).."                 ")
	BachelorSpeech.set_callback (bachelor_converse)
end
function bachelor_converse ()
	RESPONSES = {}
	local fac = math.random ()
	if fac > 0.5 then
		local interest = pick (Bachelors.current.interests)
		BachelorSpeech.say (pick (BachelorSpeech.fact_formats):format(interest.name, pick(interest)))
		local loc = pick (Bachelors.current.willGo)
		if loc == Locations.current then
			loc = Bachelors.current.spawnsAt
		end
		BachelorSpeech.set_callback (function ()
			RESPONSES = {
				{
					text = pick(RESPONSE_FORMATS.love),
					click = function ()
						BachelorSpeech.say ("You really think so?                     ")
						BachelorSpeech.set_callback (bachelor_converse)
						heart_up ()
						RESPONSES = {}
					end
				},
				{
					text = pick(RESPONSE_FORMATS.hate),
					click = function ()
						BachelorSpeech.say ("Oh, ok...                     ")
						BachelorSpeech.set_callback (bachelor_converse)
						heart_down ()
						RESPONSES = {}
					end
				},
				{
					text = ("Would you like to %s?"):format(loc.verb),
					click = function ()
						if Bachelors.current.love >= HEARTS_MAX or (Bachelors.current.love >= HEARTS_MAX/2 and not Bachelors.current.onDate) then
							BachelorSpeech.say (("Sure, I'd love to %s with you! Let's go...                  "):format(loc.verb))
							BachelorSpeech.set_callback (function ()
								Locations.current = loc
								Bachelors.current.onDate = true
								bachelor_converse ()
								card_reveal ()
							end)
						elseif Bachelors.current.onDate then
							BachelorSpeech.say ("We're already on a date, silly. Maybe if we were best friends we could hang out all day...         ")
							BachelorSpeech.set_callback (bachelor_converse)
						else
							BachelorSpeech.say (("I'd like to get to know you a little better first.               "):format(loc.verb))
							BachelorSpeech.set_callback (bachelor_converse)
						end
						RESPONSES = {}
					end
				}
			}
		end)
	else
		local function response_click ()
			for i,interest in ipairs (Bachelors.current.interests) do
				if RESPONSES[HOVERING.index].text:match(interest.name) then
					BachelorSpeech.say ("We have so much in common!                  ")
					BachelorSpeech.set_callback (bachelor_converse)
					heart_up ()
					RESPONSES = {}
					return
				end
			end
			BachelorSpeech.say ("I've never much enjoyed that.            ")
			BachelorSpeech.set_callback (bachelor_converse)
			-- heart down would be too punishing here I think
			RESPONSES = {}
		end
		local interest_responses = {
			{ text = pick(RESPONSE_FORMATS.interests):format(pick (Bachelors.current.interests).name), click = response_click},
			{ text = pick(RESPONSE_FORMATS.interests):format(pick (Interests).name), click = response_click},
			{ text = pick(RESPONSE_FORMATS.interests):format(pick (Interests).name), click = response_click}
		}
		BachelorSpeech.say (pick (BachelorSpeech.open_ended_formats))
		BachelorSpeech.set_callback (function ()
			RESPONSES = shuffle (interest_responses)
		end)
	end
end
function love.load ()
	math.randomseed(love.timer.getTime ())
	love.window.updateMode (512,512)
	love.window.setTitle ("Deeper Every D8")
	lg.setDefaultFilter ('nearest', 'nearest', 0)
	lg.setFont (love.graphics.newFont (12, 'normal'))
	Assets.load ()
	HEART_QUADS.empty = love.graphics.newQuad (0,0,8,8, Assets.Images.heart:getDimensions())
	HEART_QUADS.full = love.graphics.newQuad (8,0,8,8, Assets.Images.heart:getDimensions())
	HEART_QUADS.half = love.graphics.newQuad (16,0,8,8, Assets.Images.heart:getDimensions())
	for name,bachelor in pairs (Bachelors) do
		local x,y = unpack (bachelor.spritePos)
		bachelor.quad = lg.newQuad (x*64,y*64, 64,64, Assets.Images.portraits:getDimensions())
		bachelor.small_quad = lg.newQuad (x*16,y*16, 16,16, Assets.Images.small_portraits:getDimensions())
	end
	for name,location in pairs (Locations) do
		local x,y = unpack (location.spritePos)
		location.quad = lg.newQuad (x*128,y*128, 128,128, Assets.Images.backgrounds:getDimensions())
	end
	for i=1,3 do
		CARDS[i] = pick(Bachelors)
	end
	local bachelorList = {}
	for bachelorname, bachelor in pairs (Bachelors) do
		bachelorList[#bachelorList+1] = bachelor
	end
	shuffle (bachelorList)
	local locationList = {}
	for locname, location in pairs (Locations) do
		locationList[#locationList+1] = location
	end
	shuffle (locationList)
	for i,location in ipairs (locationList) do
		dprint ("-------finding bachelors for: "..location.name)
		location.spawnsHere = {}
		for j,bachelor in ipairs (bachelorList) do
			dprint ("looking at: "..bachelor.name)
			if not bachelor.spawnsAt then
				dprint (bachelor.name.. " has no spawn location yet")
				bachelor.willGo = {}
				local likesThisPlace = false
				for i,favoritePlace in ipairs (bachelor.favoritePlaces) do
					if favoritePlace == location then
						likesThisPlace = true
						break
					end
				end
				if likesThisPlace then
					dprint (bachelor.name.." likes "..location.name)
					for i,favoritePlace in ipairs (bachelor.favoritePlaces) do
						if favoritePlace == location then
							dprint (bachelor.name.. " will spawn at "..favoritePlace.name)
							-- they like this location. spawn them here
							location.spawnsHere[#location.spawnsHere+1] = bachelor
							bachelor.spawnsAt = location
						else
							dprint (bachelor.name.. " will go to "..favoritePlace.name)
							bachelor.willGo[#bachelor.willGo+1] = favoritePlace
						end
					end
					break
				end
			end
		end
	end
	for i,bachelor in ipairs (bachelorList) do
		if not bachelor.spawnsAt then
			dprint (bachelor.name.." didn't get a spawn location")
			for j,location in ipairs (locationList) do
				if #location.spawnsHere == 0 then
					dprint (location.name.." is empty. putting them there")
					location.spawnsHere[#location.spawnsHere+1] = bachelor
					bachelor.spawnsAt = location
					for i,favoritePlace in ipairs (bachelor.favoritePlaces) do
						bachelor.willGo[i] = favoritePlace
					end
					break
				end
			end
		end
	end
	for i,bachelor in ipairs (bachelorList) do
		if not bachelor.spawnsAt then
			dprint (bachelor.name.." is still fucked")
		end
	end
	for i,location in ipairs (locationList) do
		if #location.spawnsHere == 0 then
			dprint (location.name.." is still fucked")
		end
	end
	Locations.current = pick(Locations)
	dprint ("starting at "..Locations.current.name)
	Bachelors.current = Locations.current.spawnsHere[1]
	bachelor_hello ()
end
function love.update (dt)
	BachelorSpeech.update (dt)
end
function love.keypressed (key)
	if key == 's' and DEBUG then -- debug say
		bachelor_converse ()
	elseif key == 'd' and DEBUG then -- debug doki doki
		heart_up ()
	elseif key == 'f' and DEBUG then -- debug flip
		card_reveal ()
	elseif key == 'h' and DEBUG then -- debug hide card
		CARDS.revealed = CARDS.revealed - 1
	end
end
function love.mousemoved (x,y, dx, dy)
	HOVERING.type = 'none'
	x = x / 4
	y = y / 4
	if inrange (0,x,36) and inrange (0,y,16) then
		HOVERING.index = math.min (math.ceil (x / 12),3)
		HOVERING.type = 'card'
	elseif inrange (0,x,32) and inrange (48,y,64) then
		HOVERING.type = 'other_bachelor'
		HOVERING.index = math.min (math.ceil (x / 16),3)
	elseif inrange (99,y,128) then
		HOVERING.type = 'response'
		HOVERING.index = math.min (math.ceil ((y-99) / 6),3)
	end
end
function love.mousepressed (x, y, button)
	x = x / 4
	y = y / 4
	if     button == 1 and HOVERING.type == 'response' then
		if RESPONSES[HOVERING.index] ~= nil and RESPONSES[HOVERING.index].click ~= nil then
			RESPONSES[HOVERING.index].click ()
		end
	elseif button == 1 and HOVERING.type == 'other_bachelor' then
		if Locations.current.spawnsHere[HOVERING.index] ~= Bachelors.current then
		BachelorSpeech.say ("Ok, see you around!               ")
			local nextBachelor = Locations.current.spawnsHere[HOVERING.index]
			BachelorSpeech.set_callback (function ()
				Bachelors.current.onDate = false
				Bachelors.current = nextBachelor
				bachelor_hello ()
			end)
			RESPONSES = {}
		end
	end
end
function smolprint (text, x, y)
	lg.push ()
		lg.translate (x,y)
		lg.scale (1/2)
		lg.setColor(hex "000000")
		lg.print (text, 0, 1)
		lg.setColor(hex "ffffff")
		lg.print (text, 0, 0)
	lg.pop ()
end
function love.draw ()
	lg.push ()
		lg.scale (4)
		-- draw scene
		lg.draw (Assets.Images.backgrounds, Locations.current.quad, 0,0)
		lg.draw (Assets.Images.portraits, Bachelors.current.quad, 64,0)
		-- draw boxes
		lg.draw (Assets.Images.box, 0, 64)
		lg.draw (Assets.Images.box, 0, 96)
		lg.push ()
			lg.translate (4,68)
			lg.push ()
				lg.scale (1/2)
				-- top text
				lg.setColor(hex "000000")
				lg.print (Bachelors.current.name..":", 0,0)
				BachelorSpeech.draw ()
				lg.setColor(hex "ffffff")
				lg.translate (0,-1)
				lg.print (Bachelors.current.name..":", 0,0)
				BachelorSpeech.draw ()
			lg.pop ()
		lg.pop ()
		-- draw responses
		for i,v in ipairs (RESPONSES) do
			if HOVERING.type == 'response' and HOVERING.index == i then
				lg.setColor(1,.6,1,.3)
				lg.rectangle ('fill', 4,99+(i-1)*6, 120, 8)
				lg.setColor(hex "ffffff")
			end
			smolprint (v.text, 4,99+(i-1)*6)
		end
		-- draw hud
		-- love meter
		for i=1,HEARTS_MAX do
			if Assets.Sounds.doki_doki:isPlaying () or Assets.Sounds.oof:isPlaying () then
				lg.draw (Assets.Images.glow, 84+(i-1)*8, -12)
			end
		end
		for i=1,HEARTS_MAX do
			local quad = HEART_QUADS.empty
			if Bachelors.current.love >= i then
				quad = HEART_QUADS.full
			elseif Bachelors.current.love >= i-0.5 then
				quad = HEART_QUADS.half
			end
			lg.draw (Assets.Images.heart, quad, 96+(i-1)*8,0)
		end
		-- cards
		for i,v in ipairs (CARDS) do
			lg.draw (Assets.Images.card, (i-1)*10,0)
			if CARDS.revealed >= i then
				lg.draw (Assets.Images.small_portraits, v.small_quad, (i-1)*10,0)
			end
			if i == CARDS.revealed and Assets.Sounds.card_flip:isPlaying () then
				lg.draw (Assets.Images.glow, -8+(i-1)*10, -8)
			end
		end
		if HOVERING.type == 'card' then
			for i,v in ipairs (CARDS) do
				if i == HOVERING.index then
					lg.draw (Assets.Images.card, (i-1)*10,0)
					if CARDS.revealed >= i then
						lg.draw (Assets.Images.small_portraits, v.small_quad, (i-1)*10,0)
						smolprint (v.name, 0, 16)
					else
						smolprint ("???", 0, 16)
					end
				end
			end
		end
		-- other people in this location
		for i,v in ipairs (Locations.current.spawnsHere) do
			if v ~= Bachelors.current then
				if HOVERING.type == 'other_bachelor' and HOVERING.index == i then
					smolprint ("End date and\ntalk to "..v.name, 0, 34)
					lg.draw (Assets.Images.glow, -8, 40)
				end
				lg.draw (Assets.Images.small_portraits, v.small_quad, (i-1)*16,48)
			end
		end
	lg.pop ()
end
