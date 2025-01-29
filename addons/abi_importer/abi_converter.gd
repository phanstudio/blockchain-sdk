extends EditorScript
class_name AbiConverter

const HEADER_TEMPLATE = """extends Node
class_name {class_name}Contract

var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager

func _init(address{optional}) -> void:{address}
	var abi = {abi}
	contract = contract_manager.smartcontract(address, abi)
"""

static func convert_abi_to_gdscript(contract_name: String, abi: Variant, address:String= "") -> String:
	var processed_abi = _preprocess_abi(abi)
	var abi_string = JSON.stringify(processed_abi, "\t")
	var output = ""
	var formated_address = ""
	if address:
		formated_address = """
	if not address: # for custom abi support
		address = '{address}'
	""".format({"address": address}).rstrip("\n\t")
	
	output = HEADER_TEMPLATE.format({
		"class_name": contract_name.capitalize().replace(" ", ""),
		"address": formated_address,
		"abi": abi_string.left(abi_string.length() - 1) + "\t]",
		"optional": ": String"+(' = ""' if address else formated_address),
	})
	
	for item in processed_abi:
		if item.type != "function":
			continue
			
		var func_name = item.name
		var inputs = []
		var input_args = []
		
		for input in item.get("inputs", []):
			var gdtype = _map_input_type(input.type)
			inputs.append("%s: %s" % [input.get("name", "arg"), gdtype])
			input_args.append(input.get("name", "arg"))
		
		var return_type = "Variant"
		var custom_converter = ""
		
		# generates outputs
		if item.outputs.size() == 1:
			return_type = _map_output_type(item.outputs[0].type)
			# will create custom converter for outer custom types
			if return_type == "BigNum": 
				custom_converter = "\n\tlogs = BigNum.new(logs)"
		elif item.outputs.size() > 1:
			return_type = "Array"
			custom_converter = _generate_array_converter()
		
		var contract_type = _get_contract_type(item.get("stateMutability", "view"))
		if item.get("stateMutability", "view") == "payable":
			inputs.append("value: Dictionary")
			input_args.append("value")
		
		var default_call = "querysafely"
		var fast_run = ", fast: bool= false"
		var default_return = "\n\treturn logs"
		if contract_type == "execute":
			contract_type = '\n\t\t"execute"'
			return_type = "void"
			default_return = ""
			custom_converter = ""
			default_call = "runsafely"
			fast_run = ""
		
		output += _generate_function_template(
			func_name, inputs, input_args, return_type,
			default_return, contract_type, custom_converter,
			default_call, fast_run
		)
	
	return output

# New function to preprocess simplified ABI format
static func _preprocess_abi(abi: Variant) -> Array:
	var processed_abi = []
	
	# If ABI is already in the correct format, return as-is
	if abi is Array and abi[0] is Dictionary and abi[0].has("type"):
		return abi
	
	# Process simplified ABI format
	for func_str in abi:
		if func_str is Dictionary: # now supports multiple abi types
			processed_abi.append(func_str)
			continue
		var parsed_func = _parse_simplified_function(func_str)
		processed_abi.append(parsed_func)
	
	return processed_abi

# Parse simplified function signature
static func _parse_simplified_function(func_str: String) -> Dictionary:
	var function_parts = func_str.split("(")
	var name = function_parts[0].strip_edges().split(" ")
	var _type = name[0]
	name = name[1]
	
	var params_and_return = function_parts[1].split(")")
	var params_str = params_and_return[0]
	var return_part = params_and_return[1].strip_edges()
	
	# Parse parameters
	var inputs = []
	if params_str.strip_edges() != "":
		var param_list = params_str.split(",")
		for param in param_list:
			var param_parts = param.strip_edges().split(" ")
			inputs.append({
				"type": param_parts[0],
				"name": param_parts[1] if param_parts.size() > 1 else "arg"
			})
	
	# Parse return type
	var return_type_parts = return_part.split(" ")
	var return_type = return_type_parts[-1]
	
	var outputs = []
	for i in function_parts[2].rstrip(")").split(","):
		outputs.append(
			{"type": i}
		)
	
	var parsed_function = {
		"type": "function",
		"name": name,
		"inputs": inputs,
		"outputs": outputs,
		"stateMutability": return_type_parts[1]
	}
	
	return parsed_function

static func _map_input_type(type: String) -> String:
	match type:
		"address", "string", "bytes32":
			return "String"
		"uint256", "uint8":
			return "int"
		"address[]":
			return "Array"
		"uint256[]":
			return "Array"
		_:
			return "Variant"

static func _map_output_type(type: String) -> String:
	match type:
		"address", "string", "bytes32":
			return "String"
		"uint256", "uint8":
			return "BigNum"
		"address[]":
			return "Array[String]"
		"uint256[]":# create a output map to convert all outputs to bignum
			return "Array[Bignum]"
		_:
			return "Variant"

static func _generate_array_converter() -> String:
	return """
	var outputs = []
	for output in logs:
		if output is BigNum:
			output = BigNum.new(output)
		outputs.append(output)
	logs = outputs
"""
	pass

static func _get_contract_type(stateMutability: String) -> String:
	match stateMutability:
		"nonpayable", "payable":
			return "execute"
		_:
			return ""

static func _generate_function_template(
	func_name: String, inputs: Array, input_args: Array,
	return_type: String, default_return: String,
	contract_type: String, custom_converter: String,
	default_call: String, fast_run: String,
) -> String:
	var args = "\n\t\t[]"
	if not input_args.is_empty():
		args = "\n\t\t[" + ", ".join(input_args) + "]"
	var fast_default = "\n\t\tfast" if not contract_type else ""
	var function_template =  """
func {func_name}({params}{fast_run}) -> {return_type}:
	var logs = await contract_manager.{default_call}(
		contract.{func_name},{args},{contract_type}{fast_default}
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling {func_name}, %s" % 
		[contract_manager.output_logs["error"]]
	);{custom_converter}{default_return}
"""
# i should change assert to print err, then return ERROR
	function_template= function_template.format({
		"func_name": func_name,
		"params": ", ".join(inputs),
		"args": args,
		"return_type": return_type,
		"default_return": default_return,
		"contract_type": contract_type,
		"custom_converter": custom_converter,
		"default_call": default_call,
		"fast_run": fast_run,
		"fast_default": fast_default,
	})
	return function_template

## For converting from .gdfile using it directly from code run
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
