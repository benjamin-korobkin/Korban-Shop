extends ColorRect

func _on_Game_handleMainMenuBg(show):
	if show:
		show()
	else:
		hide()
