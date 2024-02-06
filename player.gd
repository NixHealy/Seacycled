extends CharacterBody2D

var norm_tex = load("res://img/fish.png")
var att_tex = load("res://img/attack.png")

var attacking = false

func _physics_process(delta):
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): #might wanna change this so its a quick attack
		$Fish.set_texture(att_tex)						#instead of lasting as long as you hold it
		attacking = true
	else:
		$Fish.set_texture(norm_tex)
		attacking = false
	
	var direction
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): 
		direction = get_viewport().get_mouse_position() - get_global_transform_with_canvas().get_origin()
		velocity = direction * (log(direction.length()) / log(10)) #faster when mouse is futher away
		move_and_slide()
		
		#for above, consider changing so its more of a click and go here
		#instead of a hold and continuously move towards it
		#since constantly holding down hurts fingers
		
		#rotation = atan(velocity.y / velocity.x) #removed because it wasnt playing nice with collision
		#rotation_degrees = snapped(rotation_degrees, 45)
		if velocity.x > 0:
			$Fish.flip_h = true
		else:
			$Fish.flip_h = false
			
		for body in %Area2D.get_overlapping_bodies(): #for everything nearby
			if attacking == true:
				if body.has_method("die"): #just to check
					body.die() #MURDER
# test comment
