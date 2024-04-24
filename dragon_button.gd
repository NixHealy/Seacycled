extends Button

func _on_pressed():
	if %Player.chumks >= 10:
		%Player.chumks -= 10
		%Dragon.visible = true
		%Dragon.activated = true
		%DragonButton.disabled = true
		%DragonPopup.visible = false
		%DragonSpeech.visible = false

func _on_mouse_entered():
	if !%DragonButton.disabled:
		%DragonPopup.visible = true
		%DragonSpeech.visible = false

func _on_mouse_exited():
	if !%DragonButton.disabled:
		%DragonPopup.visible = false
		%DragonSpeech.visible = true
