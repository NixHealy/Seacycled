extends Button

func _on_pressed():
	if %Player.chumks >= 5:
		%Player.chumks -= 5
		%Wrasse.visible = true
		%Wrasse.activated = true
		%WrasseButton.disabled = true
		%WrassePopup.visible = false
		%WrasseSpeech.visible = false

func _on_mouse_entered():
	if !%WrasseButton.disabled:
		%WrassePopup.visible = true
		%WrasseSpeech.visible = false

func _on_mouse_exited():
	if !%WrasseButton.disabled:
		%WrassePopup.visible = false
		%WrasseSpeech.visible = true
