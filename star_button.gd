extends Button

func _on_pressed():
	if %Player.chumks >= 5:
		%Player.chumks -= 5
		%Starfishes.visible = true
		for star in %Starfishes.get_children():
			star.activated = true
		%StarButton.disabled = true
		%StarPopup.visible = false
		%StarSpeech.visible = false

func _on_mouse_entered():
	if !%StarButton.disabled:
		%StarPopup.visible = true
		%StarSpeech.visible = false

func _on_mouse_exited():
	if !%StarButton.disabled:
		%StarPopup.visible = false
		%StarSpeech.visible = true
