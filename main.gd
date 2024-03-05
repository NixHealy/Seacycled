extends Node

@export var wave = 1
@export var grace = false
var all_collected = true
var starting = true
var paused = false

func _ready():
	%GameOver.visible = false
	%GraceLabel.visible = false
	%HelpText.visible = false

func _process(delta):
	%StartLabel.text = str(ceil(%StartTimer.time_left - 1))
	if %StartTimer.time_left < 1:
		%StartLabel.text = "GO!"
	
	if Input.is_action_just_pressed("pause") and paused == false:
		paused = true
		for timer in %ContinuousTimers.get_children():
			timer.paused = true
		for node in get_tree().get_nodes_in_group("enemy"):
			node.paused = true
			
	if Input.is_action_just_pressed("pause") and paused == true:
		paused = false
		for timer in %ContinuousTimers.get_children():
			timer.paused = false
	
	if starting == false and paused == false:
		%EnemyTimer.wait_time = 1 - 0.1 * wave #definitely wanna adjust the timing on this
		
		if %ProgressBar.value >= 100:
			%ProgressBar.value = 0
			wave += 1
			%WaveLabel.text = "Wave " + str(wave)
			
		#%GraceLabel.text = str(roundi(%GraceTimer.time_left))
		%ChumkLabel.text = str(%Player.chumks)
		%HealthBar.value = %Coral.health
		
		all_collected = true
		
		if grace == true:
			for i in get_children():
				if i.is_in_group("collectable"):
					all_collected = false
					break
					
		if all_collected == true and grace == true:
			%HelpText.text = "Now heal the coral\nor spend those chumks on allies!"
			%GraceLabel.visible = true
		else:
			%HelpText.text = "Wave Over!\nCollect all the chumks!"
			%GraceLabel.visible = false
		
		if grace == true and all_collected == true and Input.is_key_pressed(KEY_ENTER):
			grace = false
			%WaveTimer.wait_time += 0.1
			%WaveTimer.start()
			%EnemyTimer.start()
			%PollutionTimer.start()
			%GraceLabel.visible = false
			%HelpText.visible = false

# If wave 1, only trevally enemies should spawn
# If wave 2, trevally and crab enemies should spawn
# If wave 3, trevally, crab and barracuda enemies should spawn
# wave 4+, all enemy types should spawn

func spawn_mob():
	var num = randi_range(1, 100)
	var new_mob = null
	
	# WAVE 1: Only Trevally enemies can spawn
	if wave == 1:
		new_mob = preload("res://trevally_enemy.tscn").instantiate()
		
	# WAVE 2: Trevally and Crab enemies can spawn
	elif wave == 2:
		if num >= 1 && num <= 70:
			new_mob = preload("res://trevally_enemy.tscn").instantiate()
		else:
			new_mob = preload("res://crab_enemy.tscn").instantiate()
			
	# WAVE 3: Trevally, Crab and Barracuda enemies can spawn
	elif wave == 3:
		if num >= 1 && num < 50:
			new_mob = preload("res://trevally_enemy.tscn").instantiate()
		elif num >= 50 && num < 80:
			new_mob = preload("res://crab_enemy.tscn").instantiate()
		else:
			new_mob = preload("res://enemy.tscn").instantiate()
			
	# WAVE 4+: All enemy types can spawn
	else:
		if num >= 1 && num < 20:
			# Spawn Barracuda enemy, medium chance
			new_mob = preload("res://enemy.tscn").instantiate()
		elif num >= 20 && num < 50:
			# Spawn Crab enemy, high chance
			new_mob = preload("res://crab_enemy.tscn").instantiate()
		elif num >= 50 && num < 90:
			# Spawn Trevally enemy, high chance
			new_mob = preload("res://trevally_enemy.tscn").instantiate()
		else:
			# Spawn Parrotfish enemy, low chance
			new_mob = preload("res://parrotfish_enemy.tscn").instantiate()
	
	var numPath = randi_range(1, 2) #picks a random path to put it on
	if numPath == 1:
		%Path1.progress_ratio = randf() #chooses a point in the path
		new_mob.global_position = %Path1.global_position #and puts it there
	if numPath == 2:
		%Path2.progress_ratio = randf()
		new_mob.global_position = %Path2.global_position
	
	add_child(new_mob) #adds it to the scene
	
func spawn_pollution():
	var new_poll = preload("res://pollution.tscn").instantiate()
	%PollowPath.progress_ratio = randf()
	new_poll.global_position = %PollowPath.global_position
	
	add_child(new_poll)

func _on_enemy_timer_timeout(): #timer between mob spawns
	spawn_mob() 
	
func _on_pollution_timer_timeout():
	spawn_pollution()

func _on_coral_died(): #oh no the coral is dead
	%Coral.health = 0
	%GameOver.visible = true #show the game over screen
	get_tree().paused = true

func _on_wave_timer_timeout():
	%ProgressBar.value += 1
	
	if %ProgressBar.value >= 100: #if the wave is done
		%WaveTimer.stop()
		%EnemyTimer.stop()
		%PollutionTimer.stop()
		
		var enemies = get_tree().get_nodes_in_group("enemy") #delete all the enemies
		for enemy in enemies:
			enemy.queue_free()
		var pollutions = get_tree().get_nodes_in_group("pollution") #delete all the pollution
		for pollution in pollutions:
			pollution.queue_free()
		#%Coral.health = 100
		
		# GraceTimer.start() #start a timer for the grace period
		grace = true
		%GraceLabel.visible = true
		%HelpText.visible = true
			

func _on_reset_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_start_timer_timeout():
	starting = false
	%EnemyTimer.start()
	%PollutionTimer.start()
	%WaveTimer.start()
	%StartLabel.visible = false
