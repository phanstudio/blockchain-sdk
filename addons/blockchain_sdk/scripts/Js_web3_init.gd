extends Node
class_name JsWeb3Node

var window
var provider
var _ethers
var console
var contract
var signer
var Json = JSON.new()
var logs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("web"):
		window = JavaScriptBridge.get_interface('window')
		_ethers = JavaScriptBridge.get_interface("ethers")
		var javascript_code = """
			window.current_provider = new ethers.BrowserProvider(window.ethereum);
		"""
		JavaScriptBridge.eval(javascript_code);
		provider = JavaScriptBridge.get_interface("current_provider");
		console = window.console

## Utility
func create_array(arr:Array) -> JavaScriptObject:
	var array = JavaScriptBridge.create_object('Array')
	for i in arr:
		array.push(i)
	return array

func create_big_obj(dicts: Dictionary):
	var s = "{ "
	for i in dicts.keys():
		var value = dicts[i]
		match typeof(value):
			TYPE_STRING:
				if value.replace("n", "").is_valid_int(): # big number
					s += ('%s : %s, '%[i, value])
				else:
					s += ('%s : "%s", '%[i, value])
			TYPE_NIL:
				s += ('%s : %s, '%[i, value]).replace("<null>", "null")
			_:
				s += ('%s : %s, '%[i, value])
		
	s = s.substr(0, s.length()-2)
	s += " }"
	return s

func read_big_obj(s: String) -> Dictionary:
	s = s.strip_edges().trim_prefix("{").trim_suffix("}")
	var result = {}
	# Split into key-value pairs
	var pairs = s.split(",")
	for pair in pairs:
		if ":" in pair:
			var kv = pair.split(":")
			var key = kv[0].strip_edges()
			var value = kv[1].strip_edges()
		# Try to convert value to number if possible
			if value.is_valid_int():
				value = value.to_int()
			elif value.is_valid_float():
				value = value.to_float()
			elif value == "true":
				value = true
			elif value == "false":
				value = false
			elif value == "null":
				value = null
			elif "\"" in value:
				value.replace("\"", "")
			result[key] = value
	return result

func create_jsobj(dicts: Dictionary):
	var s = create_big_obj(dicts)
	var javascript_code = """
	window.result = %s
	"""%[s]
	JavaScriptBridge.eval(javascript_code)
	var result = window.result
	delete_globals("result")
	return result

func delete_globals(varname:String):
	JavaScriptBridge.eval("delete window.%s;"%(varname))

# new utlities
## Convert a hexadecimal string to a decimal string
func hex_to_decimal_str(hex_str: String) -> String:
	# Remove '0x' prefix if present
	hex_str = hex_str.to_lower().replace("0x", "")
	
	var decimal_str = "0"
	for digit in hex_str:
		# Determine the decimal value of the hex digit
		var digit_value: int
		if digit.is_valid_int(): # For 0-9
			digit_value = digit.to_int()
		else: # For a-f
			digit_value = digit.unicode_at(0) - 97 + 10

		# Multiply the current result by 16 and add the digit value
		decimal_str = string_multiply_and_add(decimal_str, 16, digit_value)
	
	return decimal_str

## Multiply a decimal string by a factor and add another number
func string_multiply_and_add(num_str: String, multiplier: int, addend: int) -> String:
	var result = ""
	var carry = 0

	# Perform the multiplication digit by digit from right to left
	for i in range(num_str.length() - 1, -1, -1):
		var product = num_str[i].to_int() * multiplier + carry
		result = str(product % 10) + result
		carry = product / 10

	if carry > 0:
		result = str(carry) + result

	# Add the addend
	carry = addend
	for i in range(result.length() - 1, -1, -1):
		var sum_digit = result[i].to_int() + carry
		result = result.substr(0, i) + str(sum_digit % 10) + result.substr(i + 1)
		carry = sum_digit / 10

	if carry > 0:
		result = str(carry) + result

	return result

## Divide a large number string by 10^18 without converting to int or float
func divide_by_pow10(number_str: String, divisor_length = 18) -> String:
	var length = number_str.length()
	
	# If the number is smaller than 10^18, return "0.xxxxxx"
	if length <= divisor_length:
		var result = "0."
		# Add leading zeros if needed
		result += "0" * (divisor_length - length) + number_str
		return strip_trailing_zeros(result)

	# Separate the integral and fractional parts
	var integral_part = number_str.substr(0, length - divisor_length)
	var fractional_part = number_str.substr(length - divisor_length)
	
	# Remove trailing zeros in the fractional part
	fractional_part = strip_trailing_zeros(fractional_part)
	
	# Combine integral and fractional parts
	if fractional_part == "":
		return integral_part
	return integral_part + "." + fractional_part

## Helper function to strip trailing zeros from a string
func strip_trailing_zeros(number_str: String) -> String:
	while number_str.ends_with("0"):
		number_str = number_str.substr(0, number_str.length() - 1)
	return number_str

## shorten hex from 0x#### to 0x##..##
func shorten_hex(hex_string: String, header: String = "0x") -> String:
	# Ensure the string is in uppercase and starts with "0x"
	hex_string = hex_string.strip_edges()#.to_upper()
	if not hex_string.begins_with(header):
		hex_string = header + hex_string
	# Shorten the string to the first 4 and last 4 characters
	if len(hex_string) > 10:  # At least "0x" + 8 characters
		return "%s%s...%s"%[hex_string.substr(0, 4), hex_string.substr(4, 2), hex_string.right(4)]
		#return "{}{}...{}".format(hex_string.substr(0, 4), hex_string.substr(4, 2), hex_string.right(4))
	else:
		return hex_string


# wrap the wait_till() function on the promise
# eg: await wait_till(contract.createPhase(2, 1, contract_payment).then(execute_contract))
# this is how you call it
# only works for one then catch iteration, for now 
func wait_till(promise, waittime= 0.05): # add time limit to this
	var state = "None"
	while true: 
		state = await PromiseState(promise)
		await get_tree().create_timer(waittime).timeout
		if state in ["fulfilled", "rejected"]:
			break

# use to retrive the logs
# resets logs when used
# eg: var nlogs = await retrieve_logs(contract.createPhase().then(execute_contract))
# add parser for 
func retrieve_logs(operation, waittime= 0.1):
	logs = true
	operation
	while true: 
		await get_tree().create_timer(waittime).timeout
		if logs:
			break
	var log = logs
	logs = false
	return log

func JsLambda(jsstring):
	var javascript_code = """
			window.jslambda = %s
		""" % [jsstring]
	JavaScriptBridge.eval(javascript_code);
	var jslambda = window.jslambda
	window.jslambda = null
	return jslambda

func PromiseState(p):
	window.state_args = p
	var javascript_code = """
		function promiseState(p) {
			const t = {};
			return Promise.race([p, t])
				.then(v => (v === t) ? "pending" : "fulfilled", () => "rejected");
		}

		async function storePromiseResult(p) {
			try {
				const state = await promiseState(p);
				if (state === "pending") {
					window.promisestate = "pending";
				} else if (state === "fulfilled") {
					const value = await p;
					window.promisestate = "fulfilled";
				} else {
					try {
						await p;
					} catch (error) {
						window.promisestate = "rejected";
					}
				}
			} catch (error) {
				console.error("An unexpected error occurred:", error);
				window.promisestate = { state: "error", error };
			}
		}

		// Usage
		storePromiseResult(window.state_args);
	"""
	JavaScriptBridge.eval(javascript_code);
	await get_tree().create_timer(0.05).timeout
	var promise = window.promisestate
	window.promisestate = null
	return promise

func JsNew(new_obj, args):
	window._new_value = new_obj
	window._new_value_args = args
	var javascript_code = """
	window._new_value = new window._new_value(window._new_value_args);
	"""
	JavaScriptBridge.eval(javascript_code)
	var new_value = window._new_value
	window._new_value_args = null
	window._new_value = null
	return new_value

func _on_reject(args):
	var response = args[0] if args.size() > 0 else null
	console.log(response)

func new_obj():
	return JavaScriptBridge.create_object('Object') 

#func str_to_address(lstring):
	#return "(address)"+lstring
