extends Node

var pending_messages = []
var pending_messages_mutex = Mutex.new()
var kill_thread = false
var thread
var thread_semaphore = Semaphore.new()

func _add_message(message):
	pending_messages_mutex.lock()
	pending_messages.push_front(message)
	pending_messages_mutex.unlock()
	thread_semaphore.post()

func _worker(args):
	while true:
		thread_semaphore.wait()
		if kill_thread:
			break
		pending_messages_mutex.lock()
		var m = pending_messages.pop_back()
		pending_messages_mutex.unlock()
		
		var client = HTTPRequest.new()
		add_child(client)
		client.connect("request_completed", self, "_on_request_complete")
		client.request(
			"%s/logs/%s" % [Defaults.logging_server, State.get_player_name()],
			PoolStringArray(),
			true,
			HTTPClient.METHOD_POST,
			JSON.print(m)
		)

func _on_request_complete(result, response_code, headers, body):
	for child in get_children():
		if child is HTTPRequest:
			if child.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
				child.call_deferred("free")

func _ready():
	thread = Thread.new()
	thread.start(self, "_worker", null)

func _exit_tree():
	kill_thread = true
	thread_semaphore.post()
	thread.wait_to_finish()

func _log(message, type, color):
	_add_message({
		"timestamp": OS.get_unix_time(),
		"logs": [{
			"color": color,
			"data": "%s: " % type
		}, {
			"color": "black",
			"data": "%s\n" % message
		}]
	})

func info(message):
	_log(message, "INFO", "blue")

func success(message):
	_log(message, "SUCCESS", "green")

func error(message):
	_log(message, "ERROR", "red")
