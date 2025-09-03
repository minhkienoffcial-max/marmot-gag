return {
    -- Event:
    CRAFT_EVENT = { "Anti Bee Egg" },
    BUY_TRAVELING_MERCHANT = { "Bee Egg", "Paradise Egg", "Loquat", "Feijoa", "Pitcher Plant" },
    CLAIM_FAIRY_REWARD = { "Enchanted Egg", "FairyPoints", "Mutation Spray Glimmering", "Enchanted Seed Pack" },
    PLANT_EVENT_TREES = true,  -- This config will replace most plant related config
    PLACE_COSMETIC = { "Cooking Kit" },
	
    -- General:
    AUTO_UPDATE_RESTART = true,
    REDEEM_CODES = {},
    EXTRA_PET_SLOTS = 5,
    EXTRA_EGG_SLOTS = 5,
    ADD_FRIEND = false,
    OPEN_ALL_SEED_PACK = true,
    
    BUY_EGGS = { "Bug Egg", "Bee Egg", "Paradise Egg", "Mythical Egg", "Rare Summer Egg", "Common Summer Egg", "Legendary Egg", "Mythical Egg", "Rare Egg", "Uncommon Egg"},
    PLANT_EGGS = { "Enchanted Egg", "Sprout Egg", "Gourmet Egg", "Legendary Egg", "Corrupted Zen Egg", "Zen Egg", "Dinosaur Egg", "Primal Egg", "Anti Bee Egg", "Night Egg", "Bug Egg", "Paradise Egg", "Common Summer Egg",
	},
    
    BUY_SEED_SHOP = { "Romanesco", "Elder Strawberry", "Giant Pinecone", "Burning Bud", "Sugar Apple", "Ember Lily", "Beanstalk", "Cacao", "Pepper", "Mushroom", "Grape", "Mango", "Dragon Fruit", "Cactus", ["Coconut"] = 50, ["Bamboo"] = 50, ["Apple"] = 50, ["Pumpkin"] = 50, ["Watermelon"] = 50, ["Daffodil"] = 50, ["Tomato"] = 50, ["Orange Tulip"] = 50, ["Blueberry"] = 50, ["Strawberry"] = 50, ["Carrot"] = 50 },
    KEEP_SEEDS = { "Carrot" },
    KEEP_SEEDS_AFTER_MAX_PLANTS = {},
    
    FAVOURITE_FRUIT_MUTATIONS = {},  -- Stop Autosell
    SKIP_HARVEST_MUTATIONS = {},  -- Stop Harvest

    KEEP_PETS = { "Cockatrice", "Glimmering Sprite", "Imp", "Gnome", "Griffin", "Apple Gazelle", "Green Bean", "Lemon Lion", "Golden Goose", "Kitsune", "Corrupted Kitsune", "French Fry Ferret", "Lobster Thermidor",
                     "T-Rex", "Spinosaurus", "Fennec Fox", "Mimic Octopus", "Disco Bee",
                     "Butterfly", "Raccoon", "Queen Bee", "Dragonfly", "Red Fox",
                     "Ankylosaurus", "Dilophosaurus", "Brontosaurus", "Hyacinth Macaw",
                     "Moth", "Moon Cat",
                     "Night Owl", "Blood Owl", "Blood Kiwi", "Cooked Owl",
                     "Raiju", "Spaghetti Sloth", "Chicken Zombie", "Wasp", "Peach Wasp", "Tarantula Hawk", "Bee",
                     "Axolotl", "Echo Frog", "Hamster", "Maneki-neko", ["Squirrel"] = 2, ["Gorilla Chef"] = 4,
                     ["Sushi Bear"] = 1, ["Mochi Mouse"] = 1, "Koi", ["Junkbot"] = 1,
                     ["Starfish"] = 2, ["Kodama"] = 2, ["Kappa"] = 1, ["Tanchozuru"] = 2,
                     "Praying Mantis",
                     ["Toucan"] = 2, ["Capybara"] = 2, ["Rooster"] = 2, ["Seal"] = 3, ["Chicken"] = 2,
					 ["Bagel Bunny"] = 3, ["Peacock"] = 3, ["Ostrich"] = 3, ["Orange Tabby"] = 3, ["Turtle"] = 3, ["Sea Turtle"] = 3, ["Scarlet Macaw"] = 3, ["Sunny-Side Chicken"] = 2},
    KEEP_PETS_WEIGHT = 8,
    KEEP_PETS_AGE = 90,

    -- Sửa tại đây: thêm Glimmering Sprite 2 con ở đầu tiên
    EQUIP_PETS = { ["Glimmering Sprite"] = 2, ["Wasp"] = 2, ["Peach Wasp"] = 1, ["Tarantula Hawk"] = 2, ["Seal"] = 1, ["Starfish"] = 1, ["Sunny-Side Chicken"] = 2 },
    USE_PETS_FOR_UPGRADE_SLOT = { "Starfish" },
    REMOVE_PET_MAX_UPGRADE = { "Capybara", "Starfish" },  -- Unequip from garden

    BUY_GEAR_SHOP = { "Grandmaster Sprinkler", "Master Sprinkler", "Godly Sprinkler", "Advanced Sprinkler", "Basic Sprinkler", "Trading Ticket" },
    USE_SPRINKLER = { "Basic Sprinkler", "Master Sprinkler", "Godly Sprinkler", "Advanced Sprinkler", "Grandmaster Sprinkler" },

    PET_WEBHOOK_URL = "",
    SEED_WEBHOOK_URL = "", 
    NOTIFY_PETS = { "French Fry Ferret", "Mochi Mouse", "Corrupted Kitsune", "Raiju", "Mizuchi", "Bald Eagle", "Koi", "Kitsune", "Fennec Fox", "Disco Bee", "Raccoon", "Queen Bee", "Night Owl", "Dragonfly", "Butterfly", "Mimic Octopus", "Red Fox", "Brontosaurus", "T-Rex", "Ankylosaurus", "Spinosaurus" },
    NOTIFY_PETS_WEIGHT = { ["Red Giant Ant"] = 5, ["Bear Bee"] = 5, ["Tanchozuru"] = 5 },
    DISCORD_ID = "",
    WEBHOOK_NOTE = "",
    SHOW_WEBHOOK_USERNAME = false,
    SHOW_WEBHOOK_JOBID = false,
	KICK_AFTER_GIFT_PET = false,
    GIFT_USERNAME = {},
    GIFT_PET = {},
}
