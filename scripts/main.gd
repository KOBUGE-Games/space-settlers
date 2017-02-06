extends Node2D

const TOP = 0
const RIGHT = 1
const BOTTOM = 2
const LEFT = 3

const SCROLLING_SPACE = 20
const SCROLLING_STEP = 100

var scrolling = -1

onready var camera = get_node("camera_main")

func _ready():
	randomize()
	set_process_input(true)
	set_fixed_process(true)
	#OS.set_window_maximized(true)

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		if event.pos.x >= 0 and event.pos.x < SCROLLING_SPACE:
			scrolling = LEFT
		elif event.pos.x > OS.get_window_size().x - SCROLLING_SPACE and event.pos.x < OS.get_window_size().x:
			scrolling = RIGHT
		elif event.pos.y > 0 and event.pos.y < SCROLLING_SPACE:
			scrolling = TOP
		elif event.pos.y > OS.get_window_size().y - SCROLLING_SPACE and event.pos.y < OS.get_window_size().y:
			scrolling = BOTTOM
		else:
			scrolling = -1
			
func _fixed_process(delta):
	if scrolling == LEFT:
		camera.set_offset(camera.get_offset() - Vector2(SCROLLING_STEP*delta,0))
	elif scrolling == RIGHT:
		camera.set_offset(camera.get_offset() + Vector2(SCROLLING_STEP*delta,0))
	elif scrolling == TOP:
		camera.set_offset(camera.get_offset() - Vector2(0,SCROLLING_STEP*delta))
	elif scrolling == BOTTOM:
		camera.set_offset(camera.get_offset() + Vector2(0,SCROLLING_STEP*delta))


