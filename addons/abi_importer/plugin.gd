@tool
extends EditorPlugin

var file_dialog: FileDialog
var abi_importer: AbiImporter = AbiImporter.new()
var bottom_panel: Control
var generate_button: Button

func _enter_tree() -> void:
	# Create bottom panel container
	bottom_panel = Control.new()
	bottom_panel.name = "ABI Converter"
	add_control_to_bottom_panel(bottom_panel, "ABI Converter")
	
	# Add button to the bottom panel
	generate_button = Button.new()
	generate_button.text = "Generate Contract from ABI"
	generate_button.connect("pressed", _on_generate_pressed)
	bottom_panel.add_child(generate_button)
	
	# Setup file dialog
	file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILES
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.filters = ["*.json"]
	file_dialog.file_selected.connect(abi_importer._on_file_selected)
	file_dialog.files_selected.connect(abi_importer._on_files_selected)
	add_child(file_dialog)

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
