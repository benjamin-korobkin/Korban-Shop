extends Node
#sounds, used to load sounds
#--------------------------------------------
var soundsDict : Dictionary = {
	"click" : preload("res://Assets/Audio/Sfx/click_003.ogg"),
	"music" : preload("res://Assets/Audio/music/zen-garden.mp3"),
	"error" : preload("res://Assets/Audio/Sfx/error.ogg"),
	"confirmation" : preload("res://Assets/Audio/Sfx/confirmation.ogg"),
	"levelFailed" : preload("res://Assets/Audio/Sfx/levelFailed.ogg"),
	"levelCompleted" : preload("res://Assets/Audio/Sfx/levelCompleted.ogg"),
}
#Textures for GUI, used to load textures.
#--------------------------------------------
var GuiTexturesDict : Dictionary = {
	"musicOn" : preload("res://Assets/Sprites/Gui/Icons/White/2x/musicOn.png"),
	"musicOff" : preload("res://Assets/Sprites/Gui/Icons/White/2x/musicOff.png"),
	"cross" : preload("res://Assets/Sprites/Gui/Icons/White/2x/cross.png"),
	"checkMark" : preload("res://Assets/Sprites/Gui/Icons/White/2x/checkmark.png"),
}
#--------------------------------------------
#General game scenes
#--------------------------------------------
var scenesDict : Dictionary = {
	"gameNode" : "res://src/Scenes/Game.tscn",
	"card" : preload("res://src/Scenes/Gui/Card.tscn"),
	"creditsScene" : preload("res://src/Scenes/Gui/Credits.tscn"),
	"customer" : preload("res://src/Scenes/Characters/Customer.tscn"),
	"tutorialCustomer" : preload("res://src/Scenes/Characters/TutorialCustomer.tscn"),
	"tutorialGui" : preload("res://src/Scenes/Gui/TutorialGui.tscn"),
	"tutorialCard" : preload("res://src/Scenes/Gui/TutorialCard.tscn"),
}
#--------------------------------------------
#start game button names
#--------------------------------------------
var startGameLevelTextDict : Dictionary = {
	1 : {
		0 : "Tutorial",
		1 : "Level 1",
		2 : "Level 2",
	},
	2 : {
		0 : "Level 3",
		1 : "Level 4",
		2 : "Level 5",
	},
	3 : {
		0 : "Level 6",
		1 : "Level 7",
		2 : "Level 8",
	},
#	4 : {
#		0 : "Endless",
#	},
}
#--------------------------------------------
#scene dictionary reference for loading
#--------------------------------------------
var levelScenesDict : Dictionary = {
	"Tutorial" : preload("res://src/Scenes/Levels/Tutorial.tscn"),
	"Level 1" : preload("res://src/Scenes/Levels/Level 1.tscn"),
	"Level 2" : preload("res://src/Scenes/Levels/Level 2.tscn"),
	"Level 3" : preload("res://src/Scenes/Levels/Level 3.tscn"),
	"Level 4" : preload("res://src/Scenes/Levels/Level 4.tscn"),
	"Level 5" : preload("res://src/Scenes/Levels/Level 5.tscn"),
	"Level 6" : preload("res://src/Scenes/Levels/Level 6.tscn"),
	"Level 7" : preload("res://src/Scenes/Levels/Level 7.tscn"),
	"Level 8" : preload("res://src/Scenes/Levels/Level 8.tscn"),
	#"Endless" : preload("res://src/Scenes/Levels/Endless.tscn"),
}
#--------------------------------------------
#loaded on level instance when node is ready
#--------------------------------------------
var levelsTimeDict : Dictionary = {
	"Tutorial" : 150,
	"Level 1" : 150,
	"Level 2" : 180,
	"Level 3" : 240,
	"Level 4" : 300,
	"Level 5" : 360,
	"Level 6" : 390,
	"Level 7" : 420,
	"Level 8" : 450,
	#"Endless" : 3600,
}
var levelsPointTreshold : Dictionary = {
	"Tutorial" : 100,
	"Level 1" : 300,
	"Level 2" : 400,
	"Level 3" : 500,
	"Level 4" : 600,
	"Level 5" : 800,
	"Level 6" : 1000,
	"Level 7" : 1200,
	"Level 8" : 1500,
	#"Endless" : 10000,
}
#--------------------------------------------
# All the korban categories, text, and amount, this dictionary contains all the logic for orders.
# Used by LevelGui node, and Customers.
# Level -> Korban type -> Occasion -> "animals" -> Animal : Amount
# TODO: Change to 8 levels instead of 10
#--------------------------------------------
var korbansDict : Dictionary = {
	"Tutorial" : {
		"Olah -" : {
			"Woman after childbirth" : {
				"animals" : {
					"Lamb" : 1,
				}
			},
		},
	},
	"Level 1" : {
		"Olah -" : {
			"Nazir tahor" : {
					"animals" : {
						"Lamb" : 1,
					}
			},
		},
		"Asham -" : {
			"Doubtful sin" : {
				"animals" : {
						"Ram" : 1,
					}
			},
		},
	},
	"Level 2" : {
		"Chatat -" : {
			"Mussaf on Chag" : {
				"animals" : {
						"Kid" : 1,
					}
			},
			"Mussaf on Rosh Chodesh" : {
				"animals" : {
						"Kid" : 1,
					}
			},
		},
	},
	"Level 3" : {
		"Asham -" : {
			"Nazir tamei" : {
				"animals" : {
						"Lamb" : 1,
					}
			},
		},
		"Shlamim -" : {
			"Nazir tahor" : {
				"animals" : {
					"Ram" : 1,
				}
			},
		},
	},
	"Level 4" : {
		"Asham -" : {
			"Me'ilah" : {
				"animals" : {
						"Ram" : 1,
					}
			},
			"Theft" : {
				"animals" : {
						"Ram" : 1,
					}
			},
		},
	},
	"Level 5" : {
		"Olah -" : {
			"Bringing an Omer" : {
				"animals" : {
						"Lamb" : 1,
				}
			},
			"Tamid offerings" : {
				"animals" : {
						"Lamb" : 2,
					}
			},
		},
	},
	"Level 6" : {
		"Olah -" : {
			"Shabbat mussaf" : {
				"animals" : {
						"Lamb" : 2,
					}
			},
			"Mussaf of Rosh Chodesh" : {
				"animals" : {
						"Bull" : 2,
						"Ram" : 1,
						"Lamb" : 7,
					}
			},
		},
	},
	"Level 7" : {
		"Olah -" : {
			"Mussaf of Rosh Hashanah" : {
				"animals" : {
						"Bull" : 1,
						"Ram" : 1,
						"Lamb" : 7,
					}
			},
			"Mussaf Yom Kippur" : {
				"animals" : {
						"Bull" : 1,
						"Ram" : 1,
						"Lamb" : 7,
					}
			},
		},
	},
	"Level 8" : {
		"Olah -" : {
			"Mussaf Shmini Atzeret" : {
				"animals" : {
						"Bull" : 1,
						"Ram" : 1,
						"Lamb" : 7,
					}
			},
		},
		"Chatat -" : {
			"Yom Kippur (Communal)" : {
				"animals" : {
						"Kid" : 1,
					}
			},
		},
	},
	"Endless" : {
		"Asham -" : {
			"Metzora" : {
				"animals" : {
					"Lamb" : 1,
				}
			},
		},
	},
}
#--------------------------------------------
