extends Button
class_name JsonHolder

var changed_text = ""
var json_files = []
var error_text: Label

func _ready() -> void:
	text = "Drop json files"
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("files")

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var files = data.get("files", [])
	
	if files.is_empty():
		return
	if changed_text == "":
		changed_text = text
	
	json_files = []
	if files.size() > 1:
		for i in files:
			if i.get_extension() == "json":
				json_files.append(i)
	else:
		var file_path = files[0]
		if file_path.get_extension() == "json":
			json_files.append(file_path)
	text = ", ".join(json_files) # "%s files ready"%[files.size()]
	if json_files.size() == 0:
		text = changed_text
		if error_text:
			error_text.text = "*Should be a .json file"
			error_text.self_modulate = Color.INDIAN_RED
	else:
		error_text.text = ""
