extends Node
class_name BigNum

var actual_value = "0"
var value = "0n":
	set(newvalue):
		if newvalue.ends_with("n"):
			actual_value = newvalue.replace("n", "")
			value = newvalue
		else:
			actual_value = newvalue
			value = newvalue+"n"
	get:
		return value
# add an error

func _init(_value: Variant=0) -> void: # initialize value
	if _value is BigNum: # copy
		value = _value.value
	elif typeof(_value) == TYPE_STRING:
		value = _value
	else:
		if typeof(_value) != TYPE_INT and typeof(_value) != TYPE_FLOAT:
			handelerror("Unknown data type passed!")
		else:
			value = str(_value)

func add(_value:BigNum):
	# try to convert to big number first
	if _value is not BigNum:
		handelerror("%s should be a BigNum"%[str(_value)])
		return
	value = _add_strings(actual_value,_value.actual_value) # check for n and add it

func sub(_value:BigNum):
	# try to convert to big number first
	if _value is not BigNum:
		handelerror("%s should be a BigNum"%[str(_value)])
		return
	value = _subtract_strings(actual_value,_value.actual_value) # check for n and add it

func mult(_value:BigNum):
	# try to convert to big number first
	if _value is not BigNum:
		handelerror("%s should be a BigNum"%[str(_value)])
		return
	value = _multiply_strings(actual_value,_value.actual_value) # check for n and add it

func div(_value:BigNum):
	# try to convert to big number first
	if _value is not BigNum:
		handelerror("%s should be a BigNum"%[str(_value)])
		return
	value = _divide_strings(actual_value,_value.actual_value) # check for n and add it

static func plus(num1:BigNum, num2:BigNum) -> BigNum:
	# try to convert to big number first
	if num1 is not BigNum or num2 is not BigNum:
		handelerror("%s, %s should be a BigNum"%[str(num1), str(num2)])
		return
	return BigNum.new(_add_strings(num1.actual_value,num2.actual_value))

static func minus(num1:BigNum, num2:BigNum) -> BigNum:
	# try to convert to big number first
	if num1 is not BigNum or num2 is not BigNum:
		handelerror("%s, %s should be a BigNum"%[str(num1), str(num2)])
		return
	return BigNum.new(_subtract_strings(num1.actual_value,num2.actual_value))

static func multiply(num1:BigNum, num2:BigNum) -> BigNum:
	if num1 is not BigNum or num2 is not BigNum:
		handelerror("%s, %s should be a BigNum"%[str(num1), str(num2)])
		return
	return BigNum.new(_multiply_strings(num1.actual_value,num2.actual_value))

static func division(num1:BigNum, num2:BigNum) -> BigNum:
	if num1 is not BigNum or num2 is not BigNum:
		handelerror("%s, %s should be a BigNum"%[str(num1), str(num2)])
		return
	return BigNum.new(_divide_strings(num1.actual_value,num2.actual_value))

# helper functions
static func handelerror(_error:String):
	printerr("BigNum Error: %s"%[_error])

static func _add_strings(str1: String, str2: String) -> String:
	# Pad the shorter string with leading zeroes
	while str1.length() < str2.length():
		str1 = "0" + str1
	while str2.length() < str1.length():
		str2 = "0" + str2

	var carry = 0
	var result = ""

	# Start adding from the least significant digit
	for i in range(str1.length() - 1, -1, -1):
		var digit_sum = int(str1[i]) + int(str2[i]) + carry
		result = str(digit_sum % 10) + result
		carry = digit_sum / 10

	# If there's a carry left at the end, prepend it
	if carry > 0:
		result = str(carry) + result

	return result

static func _multiply_strings(num1: String, num2: String) -> String:
	var n1 = num1.length()
	var n2 = num2.length()
	var result = []
	
	# Initialize result array with zeros
	for i in range(n1 + n2):
		result.append(0)
	
	# Multiply each digit
	for i in range(n1 - 1, -1, -1):
		var carry = 0
		var d1 = int(num1[i])
		
		for j in range(n2 - 1, -1, -1):
			var d2 = int(num2[j])
			var temp = result[i + j + 1] + (d1 * d2) + carry
			
			result[i + j + 1] = temp % 10
			carry = temp / 10
		
		result[i] += carry
	
	# Convert to string
	var output = ""
	var start = 0
	
	# Skip leading zeros
	while start < result.size() and result[start] == 0:
		start += 1
	
	# Handle case when result is 0
	if start == result.size():
		return "0"
	
	# Build final string
	for i in range(start, result.size()):
		output += str(result[i])
	
	return output

static func _divide_strings(dividend: String, divisor: String) -> String:
	# Handle division by zero
	if divisor == "0":
		push_error("Division by zero")
		return "Error"
	
	# Handle special cases
	if divisor == "1":
		return dividend
	if compare_strings(dividend, divisor) < 0:
		return "0"
	
	var current = ""
	var result = ""
	var index = 0
	
	while index < dividend.length():
		current += dividend[index]
		var quotient = 0
		
		# Find largest quotient digit
		while compare_strings(current, divisor) >= 0:
			current = _subtract_strings(current, divisor)
			quotient += 1
		
		result += str(quotient)
		
		# If current is empty, handle next digit
		if current == "":
			current = "0"
		
		index += 1
		
	# Remove leading zeros
	while result.length() > 1 and result[0] == "0":
		result = result.substr(1)
	
	return result

# Helper function to compare two number strings
static func compare_strings(str1: String, str2: String) -> int:
	if str1.length() != str2.length():
		return str1.length() - str2.length()
	
	for i in range(str1.length()):
		if int(str1[i]) != int(str2[i]):
			return int(str1[i]) - int(str2[i])
	return 0

# Helper function to subtract two number strings
static func _subtract_strings(str1: String, str2: String) -> String:
	var n1 = str1.length()
	var n2 = str2.length()
	var result = ""
	var borrow = 0
	
	# Pad shorter number with leading zeros
	while n2 < n1:
		str2 = "0" + str2
		n2 += 1
	
	for i in range(n1 - 1, -1, -1):
		var d1 = int(str1[i])
		var d2 = int(str2[i])
		var diff = d1 - d2 - borrow
		
		if diff < 0:
			diff += 10
			borrow = 1
		else:
			borrow = 0
			
		result = str(diff) + result
	
	# Remove leading zeros
	while result.length() > 1 and result[0] == "0":
		result = result.substr(1)
	
	return result
