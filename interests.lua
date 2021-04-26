local interest_list = {}
local function add (name, facts)
	facts.name = name
	interest_list[name] = facts
	--interest_list[#interest_list+1] = facts
end

add ("fish", {
	"fish are more genetically different from each other than they are from us",
	"fish never blink, so they're always watching",
	"unlike us, fish lay eggs to reproduce",
	"some fish live in salty water and some in fresh water"
})
add ("sports", {
	"exercise has many health benefits",
	"there are over 3000 different sports"
})
add ("money", {
	"money can be exchanged for goods and services",
	"without money, the global economy would collapse",
	"by accruing money one can increase their quality of life"
})
add ("food", {
	"a watched pot never boils",
	"breakfast is the most important meal of the day",
	"there are over 2000 kinds of pastries"
})
add ("trains", {
	"trains can be powered by electricity, coal, or diesel",
	"trains are used for moving freight and commuters",
	"trains have many wheels"
})
add ("cars", {
	"cars can go very fast",
	"in other countries, cars drive on the $LOCALIZED side",
	"some cars run on electricity"
})
add ("Europe", {
	"pizza was invented in Italy",
	"the Eiffel Tower is in Paris",
	"the Netherlands is one of the flattest countries in the world"
})
add ("history", {
	"the Mongols once ruled about 20% of the Earth's land",
	"Germany used to be split in two halves by a wall",
	"the Trojan War was fought over a girl"
})
add ("books", {
	"there's a lot of information in books",
	"books can take you to a different place in your head",
	"many popular movies are based on books"
})
add ("horses", {
	"horses are very heavy",
	"a single horse can produce 4 horsepower",
	"some horses have been known to eat small birds"
})
add ("boats", {
	"there are more crashed planes in the ocean than sunken ships in the sky",
	"my father was killed by a boat",
	"boats kill thousands of people every year"
})
add ("bowling", {
	"a perfect score in bowling is 300",
	"you can actually hit more than 10 pins if you can skip a lane"
})
add ("airplanes", {
	"there are more crashed planes in the ocean than sunken ships in the sky",
	"planes are very fast"
})
add ("theatre", {
	"Broadway theatres have at least 500 seats",
	"William Shakespeare wrote 38 plays in his life",
	"in ancient Greece, theatre audiences would stamp their feet instead of clapping",
	"Disney World's theatre wardrobes have over 1.2 million costumes",
	"you can't say the name of the Scottish play in a theatre, because it's bad luck"
})
add ("videogames", {
	"the best kind of video game is the dating simulator",
	"some games are made in as little as 48 hours",
	"in Diddy Kong Racing, if you go faster than normal speed, holding gas will slow you down"
})
add ("math", {
	"vector calculus has many real-world applications",
	"using set theory, it's possible to prove that 2+2=fish",
	"Euler's constant, e, is everywhere in nature",
	"everything can be described as triangles if you try"
})
add ("chess", {
	"real life is a lot like chess",
	"there are over 1500 chess grandmasters in the world",
	"Russia has the most chess grandmasters of any country",
	"chess is a beautiful dance of good and evil"
})
add ("painting", {
	"the human form is the most difficult thing to paint",
	"capturing the world on a canvas is the most important thing",
	"the oldest paint ever made was red"
})
add ("music", {
	"every place in the world has its own kinds of music",
	"music is the purest form of art, because we hear it in our souls",
	"music is the language of love"
})
add ("astronomy", {
	"the stars are very beautiful at night",
	"in the daytime the stars are still there, but you can't see them",
	"because light takes so long to travel from the stars to our eyes, we see them as they were millions of years ago, like looking into the past",
	"the atoms we're made from were once part of stars"
})
add ("fungi", {
	"there are hundreds of thousands of distinct fungi",
	"fungi are neither plants nor animals",
	"the plural of fungus is fungi",
	"mushrooms, molds, and yeasts are all examples of fungi"
})
add ("gardening", {
	"you can grow many types of vegetables in a garden",
	"things taste better when you've grown them yourself",
	"fresh tomatoes are better than anything from the store",
	"depending on when it's picked, corn can be considered a fruit or a grain"
})
add ("writing", {
	"poetry is the only way to free the demons from the soul",
	"my novel is almost 30,000 words so far",
	"it's fun to write persuasive essays",
	"sometimes I write research papers just for fun"
})
return interest_list
