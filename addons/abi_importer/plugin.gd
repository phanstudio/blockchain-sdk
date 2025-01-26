@tool
extends EditorPlugin

var file_dialog: FileDialog
var abi_importer: AbiImporter = AbiImporter.new()
var bottom_panel: Control
var generate_button: Button
var edit := JsonHolder.new()

func _enter_tree() -> void:
	# Create bottom panel container
	bottom_panel = Control.new()
	bottom_panel.name = "ABI Converter"
	add_control_to_bottom_panel(bottom_panel, "ABI Converter")
	
	# Add button to the bottom panel
	generate_button = Button.new()
	generate_button.text = "Generate Contract from ABI"
	generate_button.connect("pressed", _on_generate_pressed)
	
	var generate = Button.new() # do error handeling
	generate.text = "Generate"
	generate.connect("pressed", on_generate_pressed)
	
	var title = Label.new()
	var row = VBoxContainer.new()
	var row1 = HBoxContainer.new()
	var lab = Label.new()
	var desc = Label.new()
	var desc2 = Label.new()
	title.text = "ABI Converter"
	title.label_settings = LabelSettings.new()
	title.label_settings.font_size = 20
	desc.text = "Drag and drop json files, then click 'generate'"
	desc2.text = "click 'Generate Contract from ABI' to pick from a file"
	edit.error_text = lab
	bottom_panel.add_child(row)
	row.add_child(title)
	row.add_child(generate_button)
	row.add_child(desc2)
	row.add_child(row1)
	row.add_child(desc)
	row1.add_child(edit)
	row1.add_child(lab)
	row1.add_child(generate)
	
	#bottom_panel
	
	# Setup file dialog
	file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILES
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.filters = ["*.json"]
	file_dialog.file_selected.connect(abi_importer._on_file_selected)
	file_dialog.files_selected.connect(abi_importer._on_files_selected)
	add_child(file_dialog)

func on_generate_pressed():
	if abi_importer.generating:
		return
	for i in edit.json_files:
		abi_importer._generate_contract(i)
	if edit.error_text and edit.json_files.size() == 0:
		edit.error_text.text = "No file selected"
		edit.error_text.self_modulate = Color.INDIAN_RED

func _exit_tree() -> void:
	# Remove the bottom panel
	remove_control_from_bottom_panel(bottom_panel)
	if bottom_panel:
		bottom_panel.queue_free()
	if file_dialog:
		file_dialog.queue_free()

func _on_generate_pressed() -> void:
	if abi_importer.generating:
		return
	file_dialog.popup_centered(Vector2i(800, 600))
