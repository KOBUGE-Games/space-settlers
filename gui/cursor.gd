extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		set_pos(event.pos)