extends Control


onready var titleLabel = $Title
onready var disclaimerLabel = $DisclaimerTitle
onready var explanationLabel = $Explanation
onready var tween = $Tween

const TRANSPARENT = Color(1,1,1,0)
const OPAQUE = Color(1,1,1,1)

onready var stageOne : bool = false
onready var stageTwo : bool = false
onready var stageThree : bool = false
onready var finished : bool = false
onready var pressedSkip : bool = false

#starts the opening scene 
func _ready():
	tween.interpolate_property(titleLabel,"modulate",TRANSPARENT,OPAQUE,0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	tween.start()


# Handles the stages of opening scene, from title disappearing to disclaimer and explanation appearing and disappearing
# then loading the main game node.
func _on_Tween_tween_completed(object, key):
	if titleLabel.modulate == OPAQUE and !stageOne:

		stageOne = true
		yield(get_tree().create_timer(2),"timeout")
		tween.interpolate_property(titleLabel,"modulate",OPAQUE,TRANSPARENT,0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween.interpolate_property(disclaimerLabel,"modulate",TRANSPARENT,OPAQUE,1,Tween.TRANS_CUBIC,Tween.EASE_IN,0.5)
		tween.interpolate_property(explanationLabel,"modulate",TRANSPARENT,OPAQUE,1,Tween.TRANS_CUBIC,Tween.EASE_IN,0.5)
		tween.start()
	if disclaimerLabel.modulate == OPAQUE and !stageTwo:
		stageTwo = true
		yield(get_tree().create_timer(5),"timeout")
		tween.interpolate_property(disclaimerLabel,"modulate",OPAQUE,TRANSPARENT,1,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween.interpolate_property(explanationLabel,"modulate",OPAQUE,TRANSPARENT,1,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween.start()
	if disclaimerLabel.modulate == TRANSPARENT and stageTwo and !finished and !pressedSkip:
		finished = true
		load_game()



func load_game():
	var gameRsc = GameResources.scenesDict["gameNode"]
	get_tree().change_scene(gameRsc)

#skips the opening cutscene
func _on_SkipButton_pressed():
	$Tween.stop_all()
	pressedSkip = true
	load_game()
