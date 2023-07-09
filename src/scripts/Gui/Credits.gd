extends Control



onready var startingPos = Vector2(0,-809)
onready var creditsBg = get_node("/root/Game/Gui").get_node("CreditsBg")



func _ready():
	roll_credits()
	creditsBg.show()

func roll_credits():
	$Tween.interpolate_property($CreditsContainer,"rect_position",startingPos,Vector2(0,0),10,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(3),"timeout")
	creditsBg.hide()
	queue_free()


func _on_LeftButton_pressed():
	$Tween.stop_all()
	Sounds.play_sound("click","Sfx")
	creditsBg.hide()
	queue_free()
