extends StaticBody2D

var activated = false
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

func _ready():
	%Popup.global_rotation = 0
	
func _process(delta):
	if main.grace == true:
		modulate.a = 1
		
	if main.grace == true and main.all_collected == true && main.tutorial == false:
		#%Help.visible = true
		#%HelpLabel.text = "..."
		%Popup.visible = false
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player"):
				#%HelpLabel.text = "I'll protect the coral!\n[Cost: 1 Chumk]"
				%Popup.visible = true
	else:
		#%Help.visible = false
		%Popup.visible = false
	if activated:
		#%Help.visible = false
		%Popup.visible = false
		
	if activated == false && main.grace == true && main.all_collected == true && main.tutorial == false:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player") and Input.is_action_just_pressed("attack"):
				if body.chumks >= 10:
					body.chumks -= 10
					for urchin in get_tree().get_nodes_in_group("urchin"):
						urchin.activated = true

func _on_area_2d_body_entered(body):
	if body.has_method("get_poisoned") and activated:
		body.get_poisoned()
