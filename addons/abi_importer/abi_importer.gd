class_name AbiImporter

var generating := false

func _on_file_selected(path: String) -> void:
	_generate_contract(path)

func _on_files_selected(paths: PackedStringArray) -> void:
	for path in paths:
		_generate_contract(path)

func _generate_contract(path: String) -> void:
	generating = true
	
	# Read JSON file
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		printerr("Failed to open file: ", path)
		generating = false
		return
		
	var content = file.get_as_text()
	file.close()
	
	# Parse and validate JSON
	var json = JSON.parse_string(content)
	if not json or typeof(json) != TYPE_DICTIONARY:
		printerr("Invalid JSON format in file: ", path)
		generating = false
		return
		
	if not json.has_all(["name", "address", "Abi"]):
		printerr("Missing required fields in JSON: ", path)
		generating = false
		return
	
	# Generate GDScript
	var gdscript = AbiConverter.convert_abi_to_gdscript(
		json.name,
		json.address,
		json.Abi
	)
	
	# Save GDScript file
	#var output_path = path.get_basename() + ".gd"
	var output_dir = path.get_base_dir()
	var output_path = output_dir.path_join("%s.gd" % json.name)
	var output_file = FileAccess.open(output_path, FileAccess.WRITE)
	if output_file:
		output_file.store_string(gdscript)
		output_file.close()
		print("Generated contract script: ", output_path)
		
		# Refresh the editor
		EditorInterface.get_resource_filesystem().scan()
	else:
		printerr("Failed to write output file: ", output_path)
	
	generating = false
