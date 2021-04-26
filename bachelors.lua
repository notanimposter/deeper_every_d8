local Interests = require 'interests'
local Locations = require 'locations'

return {
	Houki = {
		name = "Houki",
		spritePos = {0,0},
		love = 0.5,
		interests = {
			Interests.sports,
			Interests.gardening,
			Interests.horses,
			Interests.videogames,
			Interests.chess
		},
		favoritePlaces = {
			Locations.park,
			Locations.university,
			Locations.hill
		}
	},
	Raina = {
		name = "Raina",
		spritePos = {1,0},
		love = 0.5,
		interests = {
			Interests.Europe,
			Interests.history,
			Interests.money,
			Interests.books,
			Interests.music
		},
		favoritePlaces = {
			Locations.bookshop,
			Locations.university,
			Locations.restaurant
		}
	},
	Katsumi = {
		name = "Katsumi",
		spritePos = {2,0},
		love = 0.5,
		interests = {
			Interests.cars,
			Interests.history,
			Interests.money,
			Interests.math,
			Interests.books
		},
		favoritePlaces = {
			Locations.bookshop,
			Locations.walk,
			Locations.stargazing
		}
	},
	Masayuki = {
	 	name = "Masayuki",
		spritePos = {3,0},
		love = 0.5,
		interests = {
			Interests.horses,
			Interests.theatre,
			Interests.astronomy,
			Interests.trains,
			Interests.fish
		},
		favoritePlaces = {
			Locations.river,
			Locations.stargazing,
			Locations.walk
		}
	},
	Kihiro = {
		name = "Kihiro",
		spritePos = {0,1},
		love = 0.5,
		interests = {
			Interests.writing,
			Interests.theatre,
			Interests.sports,
			Interests.bowling,
			Interests.astronomy
		},
		favoritePlaces = {
			Locations.bookshop,
			Locations.stargazing,
			Locations.park
		}
	},
	Toyomi = {
		name = "Toyomi",
		spritePos = {1,1},
		love = 0.5,
		interests = {
			Interests.music,
			Interests.food,
			Interests.cars,
			Interests.painting,
			Interests.boats
		},
		favoritePlaces = {
			Locations.river,
			Locations.restaurant,
			Locations.walk
		}
	},
	Kazuho = {
		name = "Kazuho",
		spritePos = {2,1},
		love = 0.5,
		interests = {
			Interests.airplanes,
			Interests.chess,
			Interests.math,
			Interests.videogames,
			Interests.trains
		},
		favoritePlaces = {
			Locations.hill,
			Locations.university,
			Locations.park
		}
	},
	Akehi = {
		name = "Akehi",
		spritePos = {3,1},
		love = 0.5,
		interests = {
			Interests.food,
			Interests.fish,
			Interests.fungi,
			Interests.painting,
			Interests.airplanes
		},
		favoritePlaces = {
			Locations.river,
			Locations.restaurant,
			Locations.hill
		}
	}
}
