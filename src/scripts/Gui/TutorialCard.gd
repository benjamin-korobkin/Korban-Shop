extends Node2D

onready var KorbanotDict : Dictionary
onready var occasionText : String 

onready var occasion : Label = $CardButton/Occasion
onready var korban : Label = $CardButton/Korban
onready var tween : Tween = $CardButton/Tween
onready var mainTween : Tween = $MainTween
onready var cardButton : Button = $CardButton
onready var positionName 
onready var customerNodePath
onready var cardsMenu = get_parent()
onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")
const FLIP_TIME : float = 0.8
const HIGHLIGHT_COLOR = Color.yellow#light blue#Color(0.568627, 0.921569, 0.956863)
const OPAQUE : Color = Color(1,1,1,1)
const TRANSPARENT : Color = Color(1,1,1,0)

signal handleHighlights
signal playCustomerGui

func _ready():
	connect("handleHighlights",cardsMenu,"handle_highlights")
	set_lables()
	customerNodePath.cardNodePath = self
	connect("playCustomerGui",customerNodePath,"check_order_condition")

#sets all the texts based on the order dictionary
func set_lables():
	occasion.text = occasionText
	var korbanText : String
	for korbanot in KorbanotDict.size():
		korbanText += str(KorbanotDict.keys()[korbanot]) + " - " + str(KorbanotDict.values()[korbanot]) + "\n"
	korban.text = korbanText

#disables card and activates flipping animation.
var clickedOnce : bool = false
signal cardExp7
func _on_CardButton_pressed():
	if !clickedOnce:
		connect("cardExp7",levelGui.get_node("TutorialGui"),"card_exp_7",[],CONNECT_ONESHOT)
		emit_signal("cardExp7")
	Sounds.play_sound("click","Sfx")
	cardButton.disabled = true
	if occasion.modulate == OPAQUE:
		tween.interpolate_property(occasion,"modulate",OPAQUE,TRANSPARENT,FLIP_TIME,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween.start()
	else:
		tween.interpolate_property(korban,"modulate",OPAQUE,TRANSPARENT,FLIP_TIME,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween.start()

#handles card "flip" animation, hiding and showing the korbam/occasion text.
func _on_Tween_tween_completed(object, key):
	cardButton.disabled = false
	if occasion.modulate == TRANSPARENT and !korban.visible:
		occasion.hide()
		korban.modulate = TRANSPARENT
		korban.show()
		tween.interpolate_property(korban,"modulate",TRANSPARENT,OPAQUE,FLIP_TIME,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween.start()
	elif korban.modulate == TRANSPARENT and !occasion.visible:
		korban.hide()
		occasion.modulate = TRANSPARENT
		occasion.show()
		tween.interpolate_property(occasion,"modulate",TRANSPARENT,OPAQUE,FLIP_TIME,Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween.start()

#shows card and starts tween to enlarge scale to 1,1
func show():
	cardButton.disabled = true
	modulate = TRANSPARENT
	visible = true
	mainTween.interpolate_property(self,"modulate",TRANSPARENT,OPAQUE,FLIP_TIME,Tween.TRANS_CUBIC,Tween.EASE_IN)
	mainTween.start()



var highlighted : bool = false
# Highlights card and calls parent to remove highlight from the rest of the cards.
func add_highlight():
	if !highlighted:
		emit_signal("handleHighlights",self)
		highlighted = true
		occasion.add_color_override("font_color",HIGHLIGHT_COLOR)
		korban.add_color_override("font_color",HIGHLIGHT_COLOR)


# Rremoves card highlight
func remove_highlight():
	highlighted = false
	occasion.add_color_override("font_color",Color.white)
	korban.add_color_override("font_color",Color.white)


#if card scale == 0, queue free activates, and also when starting and the appear animation ends enables button.
func _on_MainTween_tween_completed(object, key):
	if self.scale == Vector2(0,0):
		queue_free()

#opens card position for the next card and calls disappear_animation()
func remove_self_and_customer():
	get_parent().highlightedCard = null
	cardsMenu.openPositions[positionName]["open"] = true
	disappear_animation()

#activates disappear animation using tween
func disappear_animation():
	mainTween.interpolate_property(self,"scale",Vector2(1,1),Vector2(0,0),1.0,Tween.TRANS_BOUNCE,Tween.EASE_IN)
	mainTween.start()


#activates customers gui using signal and calls remove_self_and_customer() if isOrderComplete true
func activate_customer_ui(isOrderComplete):
	if isOrderComplete:
		remove_self_and_customer()
		emit_signal("playCustomerGui",isOrderComplete)
	else:
		emit_signal("playCustomerGui",isOrderComplete)


func enable_button():
	cardButton.disabled = false
