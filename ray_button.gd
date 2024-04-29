extends Button

func _on_pressed():
	if %Player.chumks >= 20:
		%Player.chumks -= 20
		%Ray.visible = true
		%Ray.activated = true
		%RayButton.disabled = true
		%RayPopup.visible = false
		%RaySpeech.visible = false

func _on_mouse_entered():
	if !%RayButton.disabled:
		%RayPopup.visible = true
		%RaySpeech.visible = false

func _on_mouse_exited():
	if !%RayButton.disabled:
		%RayPopup.visible = false
		%RaySpeech.visible = true
