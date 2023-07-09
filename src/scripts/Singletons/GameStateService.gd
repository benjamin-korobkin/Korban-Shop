extends Node
#responsible for saving and loading data from using gameStateHelper nodes


var savePath = "user://save.dat"


var globalData : Dictionary = {
	"Tutorial" : true,
	"Level 1" : false,
	"Level 2" : false,
	"Level 3" : false,
	"Level 4" : false,
	"Level 5" : false,
	"Level 6" : false,
	"Level 7" : false,
	"Level 8" : false,
	"Level 9" : false,
	"Level 10" : false,
	"Endless" : false,
	"startMenuPage" : 1
}

func _ready():
	load_data()


func add_data(key,data):
	if globalData.has(key):
		globalData[key] = data


#create a new file,encryptes and writes data dictionary into it BnJMnKOrbKIn10102 = password.
func save_data():
	var file = File.new()
	var error = file.open_encrypted_with_pass(savePath,File.WRITE,"BnJMnKOrbKIn10102")
	if error == OK:

		file.store_var(globalData)
		file.close()

#loads the saved data when opening the game
func load_data():
	var file = File.new()
	if file.file_exists(savePath):
		var error = file.open_encrypted_with_pass(savePath,File.READ,"BnJMnKOrbKIn10102")
		if error == OK:
			var gameData = file.get_var()
			file.close()
			globalData = gameData
