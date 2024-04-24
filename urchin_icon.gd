extends Button

func _on_pressed():
	if %Player.chumks >= 10:
		%Player.chumks -= 10
		%Urchins.visible = true
		for urchin in %Urchins.get_children():
			urchin.activated = true
		%UrchinButton.disabled = true
		%UrchinPopup.visible = false
		%UrchinSpeech.visible = false

func _on_mouse_entered():
	if !%UrchinButton.disabled:
		%UrchinPopup.visible = true
		%UrchinSpeech.visible = false

func _on_mouse_exited():
	if !%UrchinButton.disabled:
		%UrchinPopup.visible = false
		%UrchinSpeech.visible = true
