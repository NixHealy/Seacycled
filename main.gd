extends Node

var score = 0
var wave = 1

func _ready():
	%GameOver.visible = false

func _process(delta):
	if %ProgressBar.value >= 100:
		%ProgressBar.value = 0
		%EnemyTimer.wait_time -= 0.2
		wave += 1
		%WaveLabel.text = "Wave " + str(wave)

func spawn_mob():
	var new_mob = preload("res://enemy.tscn").instantiate() #makes an enemy
	var num = randi_range(1, 2) #picks a random path to put it on
	
	if num == 1:
		%Path1.progress_ratio = randf() #chooses a point in the path
		new_mob.global_position = %Path1.global_position #and puts it there
	if num == 2:
		%Path2.progress_ratio = randf()
		new_mob.global_position = %Path2.global_position
	
	add_child(new_mob) #adds it to the scene

func _on_timer_timeout(): #timer between mob spawns
	spawn_mob() #add thing to make the timer faster over time maybe. 
				#but thats just temporary until we get waves set up

func _on_coral_died(): #oh no the coral is dead
	%GameOver.visible = true #show the game over screen
	get_tree().paused = true #stop the game


func _on_score_timer_timeout():
	score += 1
	%ScoreLabel.text = str(score)


func _on_wave_timer_timeout():
	%ProgressBar.value += 1
