# should really be its own scene

extends StaticBody2D

func _process(delta):
	position.x = %Player.global_position.x 
