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
	var abi_string = JSON.stringify(abi, "\t")
	var output = HEADER_TEMPLATE.format({
		"class_name": contract_name.capitalize().replace(" ", ""),
		"address": address,
		"abi": abi_string.left(abi_string.length() - 1) + "\t]"
	})
	
	# work on type event, add functions for dfferent types
	# add custom input for payables
	for item in abi: 
		if item.type != "function": 
			continue
			
		var func_name = item.name
		var inputs = []
		var input_args = []
		
		for input in item.get("inputs", []): # maps correctly
			var gdtype = "String" if input.type == "address" else "int"
			match input.type:
				"address":
					gdtype = "String"
				"String":
					gdtype = "String"
				"uint256": # fix
					gdtype = "int"
			inputs.append("%s: %s" % [input.name, gdtype])
			input_args.append(input.name)
		
		var return_type = "Variant" # map corrrectly make a better output mapper
		if item.outputs.size() == 1:
			var output_type = item.outputs[0].type
			match output_type:
				"address":
					return_type = "String"
				"string":
					return_type = "String"
				"uint256":
					return_type = "BigNum"
				_:
					return_type = "Variant"
		
		var custom_converter = ""
		if return_type == "BigNum":# check for the presence of bignum index and fix it
			custom_converter = "\n\tlogs = BigNum.new(logs)"
		if item.outputs.size() > 1:
			return_type = "Array"
			# but for outputs
			#for input in item.get("inputs", []): # maps correctly
				#var gdtype = "String" if input.type == "address" else "int"
				#match input.type:
					#"address":
						#gdtype = "String"
					#"String":
						#gdtype = "String"
					#"uint256": # fix
						#gdtype = "int"
				#inputs.append("%s: %s" % [input.name, gdtype])
				#input_args.append(input.name)
			# and custom logic to change uints to bignums
		
		var contract_type = ""
		match item.stateMutability:
			"nonpayable":
				contract_type = "execute"
			"payable":
				contract_type = "execute"
				inputs.append("%s: %s" % ["value", "Dictionary"]) # to pay value
				input_args.append("value")
		
		var default_return = "\n\treturn logs"
		
		if contract_type == "execute":
			contract_type = '\n\t\t"execute"'
			return_type = "void"
			default_return = ""
			custom_converter = ""
		
		var function_template = """
func {func_name}({params}) -> {return_type}:
	var logs = await contract_manager.runsafely(
		contract.{func_name},{args},{contract_type}
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getSeiAddr, %s" % 
		[contract_manager.output_logs["error"]]
	);{custom_converter}{default_return}
"""
		
		var args = "\n\t\t[]"
		if not input_args.is_empty():
			args = "\n\t\t[" + ", ".join(input_args) + "]"
		
		output += function_template.format({
			"func_name": func_name,
			"params": ", ".join(inputs),
			"args": args,
			"return_type": return_type,
			"default_return": default_return,
			"contract_type": contract_type,
			"custom_converter": custom_converter
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
