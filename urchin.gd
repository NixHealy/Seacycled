extends StaticBody2D

var activated = false
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

func _ready():
	modulate.a = 0.5
	
func _process(delta):
	if main.grace == true:
		modulate.a = 1
		
	if main.grace == true and main.all_collected == true:
		%Help.visible = true
		%HelpLabel.text = "..."
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player"):
				%HelpLabel.text = "I'll protect the coral!\n[Cost: 1 Chumk]"
	else:
		%Help.visible = false
	if activated:
		%Help.visible = false
		
	if activated == false && main.grace == true && main.all_collected == true:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player") and Input.is_action_just_pressed("attack"):
				if body.chumks >= 1:
					body.chumks -= 1
					activated = true

func _on_area_2d_body_entered(body):
	if body.has_method("get_poisoned") and activated:
		body.get_poisoned()
