extends Node
#class_name Blockchain

signal request_completed(result: Dictionary)
signal request_failed(error: String)
signal transaction_sent(response: Dictionary)
signal transaction_failed(error: String)

# Configuration
var node_url: String = ""
var timeout: float = 10.0
var max_retries: int = 3

# Internal state
var _http_request: HTTPRequest
var _retry_count: int = 0
var _last_request_url: String = ""
var _last_request_headers: PackedStringArray
var _last_request_method: int
var _last_request_data: String

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_http_request()

## Initializes the HTTP request node and connects signals
func _setup_http_request() -> void:
	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.connect("request_completed", _on_request_completed)
	_http_request.timeout = timeout

## Initializes the blockchain connection with a node URL
func init(url: String) -> void:
	node_url = url.strip_edges()
	if not node_url.begins_with("http"):
		node_url = "https://" + node_url
	prints("Blockchain initialized with node:", node_url)

## Queries the blockchain for information
## endpoint: API endpoint to query
## params: Dictionary of query parameters
func query_blockchain(data= {}, endpoint: String= '', params: Dictionary = {}) -> void:
	if node_url.is_empty():
		emit_signal("request_failed", "Node URL not initialized")
		return
		
	var query_string = ""
	if not params.is_empty():
		var query_params = []
		for key in params:
			query_params.append("%s=%s" % [key, params[key]])
		query_string = "?" + "&".join(query_params)
	
	var url = node_url + endpoint + query_string
	var headers = PackedStringArray(["Content-Type: application/json"])
	var method_used = HTTPClient.METHOD_POST
	var request_data = JSON.stringify(data)
	
	_last_request_url = url
	_last_request_headers = headers
	_last_request_method = method_used
	_last_request_data = request_data
	
	var error = _http_request.request(url, headers, method_used, request_data)
	if error != OK:
		emit_signal("request_failed", "Failed to send request: %d" % error)

## Sends a signed transaction to the blockchain
## signed_tx: The signed transaction data as a string
func send_transaction(signed_tx: String) -> void:
	if node_url.is_empty():
		emit_signal("transaction_failed", "Node URL not initialized")
		return
		
	var url = node_url + "/send_transaction"
	var headers = PackedStringArray(["Content-Type: application/json"])
	var data = JSON.stringify({"transaction": signed_tx})
	
	_last_request_url = url
	_last_request_headers = headers
	_last_request_method = HTTPClient.METHOD_POST
	_last_request_data = data
	
	var error = _http_request.request(url, headers, HTTPClient.METHOD_POST, data)
	if error != OK:
		emit_signal("transaction_failed", "Failed to send transaction: %d" % error)

## Handles the HTTP request completion
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		_handle_request_error(result)
		return
		
	if response_code != 200:
		_handle_response_error(response_code, body)
		return
		
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result != OK:
		emit_signal("request_failed", "Failed to parse response: %s" % json.get_error_message())
		return
		
	var response = json.get_data()

	# Determine if this was a transaction or query response
	if "/send_transaction" in _last_request_url:
		emit_signal("transaction_sent", response)
	else:
		emit_signal("request_completed", response)
	
	_retry_count = 0

## Handles HTTP request errors
func _handle_request_error(result: int) -> void:
	var error_message = "Request failed: "
	match result:
		HTTPRequest.RESULT_CHUNKED_BODY_SIZE_MISMATCH:
			error_message += "Chunked body size mismatch"
		HTTPRequest.RESULT_CANT_CONNECT:
			error_message += "Can't connect to host"
		HTTPRequest.RESULT_CANT_RESOLVE:
			error_message += "Can't resolve hostname"
		HTTPRequest.RESULT_CONNECTION_ERROR:
			error_message += "Connection error"
		HTTPRequest.RESULT_NO_RESPONSE:
			error_message += "No response"
		HTTPRequest.RESULT_TIMEOUT:
			error_message += "Request timeout"
		_:
			error_message += "Unknown error %d" % result
	
	if _retry_count < max_retries:
		_retry_count += 1
		prints("Retrying request (attempt %d of %d)..." % [_retry_count, max_retries])
		# Retry the request using stored last request information
		var error = _http_request.request(_last_request_url, _last_request_headers, _last_request_method, _last_request_data)
		if error != OK:
			emit_signal("request_failed", "Failed to retry request: %d" % error)
	else:
		_retry_count = 0
		emit_signal("request_failed", error_message)

## Handles HTTP response errors
func _handle_response_error(code: int, body: PackedByteArray) -> void:
	var error_message = "Response error %d: " % code
	if not body.is_empty():
		error_message += body.get_string_from_utf8()
	else:
		match code:
			400: error_message += "Bad Request"
			401: error_message += "Unauthorized"
			403: error_message += "Forbidden"
			404: error_message += "Not Found"
			429: error_message += "Too Many Requests"
			500: error_message += "Internal Server Error"
			502: error_message += "Bad Gateway"
			503: error_message += "Service Unavailable"
			_: error_message += "Unknown Error"
	
	emit_signal("request_failed", error_message)

## Cancels any ongoing requests
func cancel_request() -> void:
	if _http_request:
		_http_request.cancel_request()

## Cleanup when the node is removed
func _exit_tree() -> void:
	if _http_request:
		_http_request.queue_free()
