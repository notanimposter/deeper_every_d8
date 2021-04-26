local lg = love.graphics
local Assets = require 'assets'

local bachelor_saying = {
	page_timer = 0,
	page_timer_MAX = 5,
	percent_through_page = 0,
	line_we_on = 0,
	percent_through_line = 0,
	lines_as_typed_so_far = {},
	lines = {},
	callback = nil,
	is_speaking = false
}
local function bachelor_say (str)
	local width, lines = lg.getFont ():getWrap (str, 242)
	bachelor_saying.lines = lines
	bachelor_saying.lines_as_typed_so_far = {}
	bachelor_saying.page_timer = bachelor_saying.page_timer_MAX
	Assets.Sounds.professional_voice_acting:setLooping (true)
	Assets.Sounds.professional_voice_acting:play ()
	bachelor_saying.is_speaking = true
end
local function set_callback (func)
	bachelor_saying.callback = func
end
local function update (dt)
	if bachelor_saying.page_timer < 0 then
		if #bachelor_saying.lines > 3 then
			bachelor_saying.page_timer = bachelor_saying.page_timer_MAX
			for i=1,3 do
				table.remove (bachelor_saying.lines, 1) -- not ideal
				bachelor_saying.lines_as_typed_so_far = {}
				--Assets.Sounds.professional_voice_acting:setLooping (true)
				--Assets.Sounds.professional_voice_acting:play ()
			end
		end
	else
		bachelor_saying.page_timer = bachelor_saying.page_timer - dt
		-- figure out the typing stuff
		bachelor_saying.percent_through_page = (bachelor_saying.page_timer_MAX - bachelor_saying.page_timer) / bachelor_saying.page_timer_MAX
		bachelor_saying.line_we_on = bachelor_saying.percent_through_page * 3
		bachelor_saying.percent_through_line = bachelor_saying.line_we_on - math.floor (bachelor_saying.line_we_on)
		for i=1,math.ceil (bachelor_saying.line_we_on) do
			local line = bachelor_saying.lines[i] or ""
			if i == math.ceil (bachelor_saying.line_we_on) then
				line = line:sub (1, math.ceil (bachelor_saying.percent_through_line*math.max (#line, 30))) -- TODO 30 is completely arbitrary
			end
			bachelor_saying.lines_as_typed_so_far[i] = line
		end
		if math.ceil (bachelor_saying.line_we_on) == math.min (#bachelor_saying.lines, 3) and bachelor_saying.lines_as_typed_so_far[#bachelor_saying.lines_as_typed_so_far] == bachelor_saying.lines[math.ceil (bachelor_saying.line_we_on)] then
			if #bachelor_saying.lines == #bachelor_saying.lines_as_typed_so_far and bachelor_saying.is_speaking then
				Assets.Sounds.professional_voice_acting:setLooping (false)
				bachelor_saying.is_speaking = false
				if bachelor_saying.callback ~= nil then
					bachelor_saying.callback()
				end
			end
		end
	end
end
local function draw ()
	if #bachelor_saying.lines then
		for i,v in ipairs (bachelor_saying.lines_as_typed_so_far) do
			lg.print (v, 0,i*12)
		end
	end
end

local fact_formats = {
	"I just love %s. Did you know that %s?",
	"I just read another book about %s. I think %s.",
	"Someone was telling me about %s recently. They said %s.",
	"What's up with %s? Isn't it cool that %s?",
	"Have you thought about %s lately? I've heard %s.",
	"I watched a documentary about %s last night. I never knew %s.",
	"I'm glad there are so many blogs about %s. It's amazing how %s."
}
local open_ended_formats = {
	"What do you like to do in your spare time?",
	"What's your favorite thing to do on the weekend?",
	"Do you have any interests?"
}

-- do this because we moved this code haphazardly out of main.lua
return {
	say = bachelor_say,
	set_callback = set_callback,
	update = update,
	draw = draw,
	fact_formats = fact_formats,
	open_ended_formats = open_ended_formats
}
