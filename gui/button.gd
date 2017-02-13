extends TextureButton

export var label = "Button"
export var name = "button"

func _ready():
	get_node("Label").set_text(label)

func _on_button_pressed():
	if name == "quit":
		get_tree().quit()
	else:
		for window in global.main_menu.get_node("window/windows").get_children():
			window.hide()
		
	if name == "host" or name == "join" or name == "settings" or name == "help":
		global.main_menu.get_node("window/windows/"+name).show()
