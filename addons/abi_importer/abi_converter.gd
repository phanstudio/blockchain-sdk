extends EditorScript

class_name AbiConverter

const HEADER_TEMPLATE = """extends Node
class_name {class_name}Contract

var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager

func _init() -> void:
	var address = '{address}'
	var abi = {abi}
	contract = contract_manager.smartcontract(address, abi)
"""

static func convert_abi_to_gdscript(contract_name: String, address: String, abi: Array) -> String:
	var output = HEADER_TEMPLATE.format({
		"class_name": contract_name.capitalize().replace(" ", ""),
		"address": address,
		"abi": JSON.stringify(abi, "\t")
	})
	
	for item in abi:
		if item.type != "function":
			continue
			
		var func_name = item.name
		var inputs = []
		var input_args = []
		
		for input in item.get("inputs", []):
			var gdtype = "String" if input.type == "address" else "int"
			inputs.append("%s: %s" % [input.name, gdtype])
			input_args.append(input.name)
		
		var return_type = "Variant"
		if item.outputs.size() > 0:
			var output_type = item.outputs[0].type
			return_type = "String" if output_type == "address" else "int"
		
		var function_template = """
func {func_name}({params}) -> {return_type}:
	var logs = await contract_manager.runsafely(
		contract.{func_name},{args}
	)
	if logs != null:
		contract_manager.console.log(logs)
		return logs
	printerr("Error calling {func_name}")
	return {default_return}
"""
		
		var args = ""
		if not input_args.is_empty():
			args = "\n\t\t[" + ", ".join(input_args) + "]"
		
		var default_return = '""' if return_type == "String" else "0"
			
		output += function_template.format({
			"func_name": func_name,
			"params": ", ".join(inputs),
			"args": args,
			"return_type": return_type,
			"default_return": default_return
		})
	return output

static func convert_from_file(json_path: String) -> void:
	if not FileAccess.file_exists(json_path):
		printerr("File not found: ", json_path)
		return
		
	var file = FileAccess.open(json_path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	if not json or typeof(json) != TYPE_DICTIONARY:
		printerr("Invalid JSON in file: ", json_path)
		return
		
	if not json.has_all(["name", "address", "Abi"]):
		printerr("Missing required fields in JSON")
		return
	
	var output_dir = json_path.get_base_dir()
	var output_path = output_dir.path_join("%s.gd" % json.name)
	
	var gdscript = convert_abi_to_gdscript(
		json.name,
		json.address,
		json.Abi
	)
	
	var output_file = FileAccess.open(output_path, FileAccess.WRITE)
	output_file.store_string(gdscript)
	output_file.close()
	print("Generated contract script: ", output_path)
