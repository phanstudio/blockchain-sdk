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
		
	if not json.has_all(["name", "Abi"]):
		printerr("Missing required fields in JSON: ", path)
		generating = false
		return
	# Generate GDScript
	var gdscript = ""
	if json.has_all(["address"]):
		gdscript = AbiConverter.convert_abi_to_gdscript(
			json.name,
			json.Abi,
			json.address,
		)
	else:
		gdscript = AbiConverter.convert_abi_to_gdscript(
			json.name,
			json.Abi,
		)
	# Save GDScript file
	var output_dir = path.get_base_dir()
	var output_path = output_dir.path_join("%s.gd" % json.name)

	var new_paths = find_file(output_dir, json.name)
	if new_paths.size() > 0: # trying to make the changed show in the editor
		var dir = DirAccess.open(output_dir)
		for _path in new_paths:
			if dir: dir.remove(_path.get_file())
		EditorInterface.get_resource_filesystem().scan()
		await EditorInterface.get_resource_filesystem().filesystem_changed
		var new_path = output_path
		var file_occupied = false
		for i in 100000:
			if check_for_file_in_script_panel(new_path):
				file_occupied = true
				printerr("Close(%s) in script editor: "%new_path)
				new_path = output_dir.path_join("%s(%s).gd" % [json.name, i])
			else:
				output_path = new_path
				break
		if file_occupied:
			print("important")
			printerr("Close all instances of the script if open")
			printerr("Close all instances of the script in script panel manually because its not supported for now in godot")
		
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

func check_for_file_in_script_panel(new_path):
	var found = false
	for i in EditorInterface.get_script_editor().get_open_scripts():
		if i.resource_path == new_path:
			found = true
			break
	return found

func find_file(dir_path, file_regex):
	var dir = DirAccess.get_files_at(dir_path)
	var files = []
	for i in dir:
		if file_regex in i.get_file().get_basename():
			files.append(i)
	return files
