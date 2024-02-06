extends StaticBody2D

@export var health = 100

signal died

func _process(delta):
	%Sprite2D.material.set_shader_parameter("desaturate_strength", health / 100.0) #makes it less saturated
														#probably change to different texture instead when we have the art
	
	var touching = %Area2D.get_overlapping_bodies().size() #how many enemies are touching it
	health -= touching * delta * 10 #more enemies means loses health faster
	
	%Label.set_text("Health: " + str(round(health)))

	if health <= 0: #oh no its dead
		queue_free()
		died.emit() #let other things know its dead
