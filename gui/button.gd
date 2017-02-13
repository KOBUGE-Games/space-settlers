extends TextureButton

export var label = "Button"
export var name = "button"

func _ready():
	get_node("Label").set_text(label)

func _on_button_pressed():
	if name == "quit":
		get_tree().quit()
