extends StaticBody2D

@export var health = 100
@onready var player = get_node("/root/Main/Player") #fetches the coral node
@onready var vignette = get_node( "/root/Main/UI/Vignette")
@onready var main = get_node("/root/Main") #fetches the main node

var is_polluted = false
var config = ConfigFile.new()

signal died

func _ready():
	%CoralHealRect.visible = false

	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast")
		%Sprite2D.material.set_shader_parameter("active", contrast)

func _process(delta):
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var sfx
		sfx = config.get_value("Options", "sfx")
		%DamageSound.volume_db = log(sfx) * 20
	
	#health = 100
	var desat = health / 100.0
	if desat < 0:
		desat = 0
	%Sprite2D.material.set_shader_parameter("desaturate_strength", desat) #makes it less saturated
														#probably change to different texture instead when we have the art
	var polluted = 0
	
	for body in %OutsideArea.get_overlapping_bodies():
		if body.is_in_group("pollution"):
			polluted += 0.1
			
	if polluted > 0:
		is_polluted = true
	else:
		is_polluted = false
	
	%Sprite2D.material.set_shader_parameter("pollution_strength", polluted)
	health -= polluted * delta * 3 #more pollution means loses health faster
	vignette.material.set_shader_parameter("alpha", polluted * 0.5)
	
	#player.speed = 1
	#player.speed = 1 - (polluted)
	#if player.speed <= 0.1:
		#player.speed = 0.2
	
	#%CoralHealRect.visible = false
	%Popup.visible = false
	
	# Chance for player to heal the coral during grace period
	if health < 100 && main.grace == true && main.all_collected == true && main.tutorial == false:
		#%CoralHealRect.visible = true
		#%HealLabel.text = "..."
		%Popup.visible = false
		# Check if the player is on top of the coral
		for body in %HitArea.get_overlapping_bodies():
			if body.is_in_group("player"):
				#%HealLabel.text = "Come over here, click\nto heal me!\n[Cost: 5 Chumks = 5HP]"
				%Popup.visible = true
				if body.chumks >= 5:
					# Input required so user doesn't accidentally spend chumks
					if Input.is_action_just_pressed("attack"):
						# Spend 5 chumks to increase health by 5 points
						body.chumks -= 5
						health += 5

	if health <= 0: #oh no its dead
		died.emit() #let other things know its dead
		
	%HealthBar.value = health

func _on_hit_area_body_entered(body):
	if body.is_in_group("enemy"): #maybe wanna make the enemy itself responsible for much damage it deals
		if body.is_in_group("spike"):
			health -= 3
		else:
			if body.resisted == true:
				health -= 1
			if body.is_in_group("crab"):
				health -= 3
			elif body.is_in_group("parrotfish"):
				health -= 12 # Double damage for this enemy type
			else:
				health -= 6
		body.queue_free()
		%DamageSound.play()
