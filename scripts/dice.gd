extends Node2D

var rolling = false
var times
var dice_1
var dice_2

onready var timer = get_node("timer")

func _ready():
	pass

func _on_button_pressed():
	if not rolling:
		rolling = true
		times = (randi() % 15) + 15
		timer.start()
		
func _on_timer_timeout():
	if times > 0:
		times -= 1
		dice_1 = randi()%6
		dice_2 = randi()%6
		get_node("animated_sprite").set_frame(dice_1)
		get_node("animated_sprite_2").set_frame(dice_2)
		timer.start()
	else:
		printt(dice_1+1,dice_2+1)
		rolling = false
		timer.stop()
