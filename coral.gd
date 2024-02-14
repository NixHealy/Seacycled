extends StaticBody2D

@export var health = 100
@onready var player = get_node("/root/Main/Player") #fetches the coral node
@onready var vignette = get_node( "/root/Main/UI/Vignette")
signal died

func _process(delta):
	%Sprite2D.material.set_shader_parameter("desaturate_strength", health / 100.0) #makes it less saturated
														#probably change to different texture instead when we have the art
	var polluted = 0
	var touching = 0
	for body in %Area2D.get_overlapping_bodies():
		if body.is_in_group("pollution"):
			polluted += 0.1
		if body.is_in_group("enemy"): #maybe wanna make the enemy itself responsible for much damage it deals
			if body.is_in_group("crab"):
				health -= 1
			else:
				health -= 2
			body.queue_free()
	
	#health -= touching * delta * 5 #more enemies means loses health faster
	
	%Sprite2D.material.set_shader_parameter("pollution_strength", polluted)
	vignette.material.set_shader_parameter("alpha", polluted * 0.5)
	
	player.speed = 1
	player.speed = 1 - (polluted)
	if player.speed <= 0:
		player.speed = 0.1
	
	%Label.set_text("Health: " + str(round(health)))

	if health <= 0: #oh no its dead
		died.emit() #let other things know its dead
