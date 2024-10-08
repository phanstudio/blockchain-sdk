@tool
extends Node
class_name Blockchain

signal request_completed(result: Dictionary)
signal request_failed(error: String)
signal transaction_sent(response: Dictionary)
signal transaction_failed(error: String)

var node_url: String = ""
var _http_request: HTTPRequest

func _ready():
	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.connect("request_completed", _on_request_completed)

func init(url: String) -> void:
	node_url = url.strip_edges()
	if not node_url.begins_with("http"):
		node_url = "https://" + node_url

func query_blockchain(params: Dictionary) -> void:
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify(params)
	
	var error = _http_request.request(node_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		emit_signal("request_failed", "Failed to send request: %d" % error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		emit_signal("request_failed", "Request failed with code: %d" % result)
		return
		
	if response_code != 200:
		emit_signal("request_failed", "Response error: %d" % response_code)
		return
		
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result != OK:
		emit_signal("request_failed", "Failed to parse response")
		return
		
	var response = json.get_data()
	emit_signal("request_completed", response)
