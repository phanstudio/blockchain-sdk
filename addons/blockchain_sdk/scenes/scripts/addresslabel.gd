@tool
extends MarginContainer
@onready var label = %Label

@export var text := "":
	set = set_text,
	get = get_text

func set_text(new_value):
	text = new_value
	if label:  # Check if the label node exists.
		label.text = new_value

func get_text():
	return label.text
