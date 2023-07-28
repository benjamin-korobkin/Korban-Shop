extends Control


onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")
onready var timerTextureProgress = $TimerTextureProgress
onready var timeLeftLabel = $TimeLeft
onready var pointsLabel = $Points
onready var pointsTween = $PointsTween
onready var minutes
onready var seconds
onready var timeLeft
onready var points : int = 0
onready var levelPointTreshold : int
var pointsTweenActive : bool = false
signal levelFailed
signal levelComplete

func _ready():
	set_physics_process(false)
	yield(get_tree(),"idle_frame")
	connect("levelFailed",levelGui,"display_gui")
	connect("levelComplete",levelGui,"display_gui")


#sets timer and points when level is loaded
func set_timer_and_points(_timeLeft,_points):
	get_tree().paused = false
	points = 0
	levelPointTreshold = _points
	timerTextureProgress.max_value = _timeLeft
	timerTextureProgress.value = _timeLeft
	timeLeft = _timeLeft
	minutes = _timeLeft / 60
	seconds = _timeLeft % 60
	timeLeftLabel.text = "%02d:%02d" % [minutes, seconds - 1]
	pointsLabel.text = "0/" + str(_points)
	set_physics_process(true)



#updates all parameters, and emit level failed to levelGui if time is 0
func _physics_process(delta):
	pointsLabel.text = str(points) + "/" + str(levelPointTreshold)
	check_score()
	seconds-= delta
	timeLeft -= delta
	if seconds <= 0 and minutes > 0:
		seconds = 60
		minutes -= 1
	timerTextureProgress.value = timeLeft
	timeLeftLabel.text = "%02d:%02d" % [minutes, seconds]
	if seconds <= 0 and minutes <= 0:
		var level = get_node("/root/Game/Levels").get_child(0)
		emit_signal("levelFailed",false,level.name)
		Sounds.play_sound("levelFailed","Sfx3")
		set_physics_process(false)


#updates points, parameter recieved from customer.
func add_points(_points):
	var totalPoints = max(points + _points, 0)
	pointsTween.interpolate_property(self,"points",points,totalPoints,1.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pointsTween.start()
	pointsTweenActive = true

#disables pointsTweenActive bool
func _on_PointsTween_tween_completed(object, key):
	pointsTweenActive = false

#checks score if tween is active and sends a signal to levelGui if level complete
func check_score():
	var level = get_node("/root/Game/Levels").get_child(0)
	if points >= levelPointTreshold:
		pointsTween.stop_all()
		pointsTweenActive = false
		set_physics_process(false)
		emit_signal("levelComplete",true,level.name)
		Sounds.play_sound("levelCompleted","Sfx3")
