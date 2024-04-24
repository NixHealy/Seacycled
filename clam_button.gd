extends Button

func _process(delta):
	for clam in %Clams.get_children():
		if clam.is_open == false:
			%ClamButton.disabled = false

func _on_pressed():
	if %Player.chumks >= 20:
		%Player.chumks -= 20
		%Clams.visible = true
		for clam in %Clams.get_children():
			clam.open()
		%ClamButton.disabled = true
		%ClamPopup.visible = false
		%ClamSpeech.visible = false

func _on_mouse_entered():
	if !%ClamButton.disabled:
		%ClamPopup.visible = true
		%ClamSpeech.visible = false

func _on_mouse_exited():
	if !%ClamButton.disabled:
		%ClamPopup.visible = false
		%ClamSpeech.visible = true
