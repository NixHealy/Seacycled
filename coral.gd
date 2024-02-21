extends StaticBody2D

@export var health = 100
@onready var player = get_node("/root/Main/Player") #fetches the coral node
@onready var vignette = get_node( "/root/Main/UI/Vignette")
@onready var main = get_node("/root/Main") #fetches the main node
signal died

func _process(delta):
	var desat = health / 100.0
	if desat < 0:
		desat = 0
	%Sprite2D.material.set_shader_parameter("desaturate_strength", desat) #makes it less saturated
														#probably change to different texture instead when we have the art
	var polluted = 0
	var touching = 0
	for body in %OutsideArea.get_overlapping_bodies():
		if body.is_in_group("pollution"):
			polluted += 0.1
	
	#health -= touching * delta * 5 #more enemies means loses health faster
	
	%Sprite2D.material.set_shader_parameter("pollution_strength", polluted)
	vignette.material.set_shader_parameter("alpha", polluted * 0.5)
	
	player.speed = 1
	player.speed = 1 - (polluted)
	if player.speed <= 0.1:
		player.speed = 0.2
	
	%Label.set_text("Health: " + str(round(health)))

	if health <= 0: #oh no its dead
		died.emit() #let other things know its dead

func _on_hit_area_body_entered(body):
	if body.is_in_group("enemy"): #maybe wanna make the enemy itself responsible for much damage it deals
		if body.is_in_group("crab"):
			health -= 3
		elif body.is_in_group("parrotfish"):
			health -= 12 # Double damage for this enemy type
		else:
			health -= 6
		body.queue_free()
