extends Node

class_name Sequence

var sequence_index:= 0
var _current_sequence_call: Callable
var _one_shot = false
var _error: Callable

var on_error:= JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		print(
			"Error occured in %s: "%(sequence_index),
			response,
		)
		_error.call()
)

var on_success:= JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		run(response)
)

func _init(start_funtion: Callable, error: Callable, oneshot:= false) -> void:
	_current_sequence_call = start_funtion
	_one_shot = oneshot
	_error = error

func update(next_function: Callable) -> void:
	sequence_index += 1
	_current_sequence_call = next_function

func run(args):
	_current_sequence_call.call(args)
	if _one_shot:
		_current_sequence_call = func(_args):pass
		queue_free()

func runasynic(jsobj):
	jsobj.then(on_success).catch(on_error)
