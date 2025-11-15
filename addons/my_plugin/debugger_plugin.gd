@tool
extends EditorDebuggerPlugin


func _has_capture(capture: String) -> bool:
	return capture == "my_plugin"


func _capture(message: String, data: Array, session_id: int) -> bool:
	if message == "my_plugin:test":
		var stack: Array = data
		_print(session_id, "_capture(): Called test func.")
		_print_stack(session_id, stack)
		return true
	elif message == "my_plugin:receive_stack":
		var from: String = data[0]
		var stack: Array = data[1]
		if from == "session_breaked":
			_print(session_id, "_capture(): Hit breakpoint.")
			_print_stack(session_id, stack)

			# This is an undocumented feature. You can't capture built-in messages, but you can
			# send them yourself. See `RemoteDebugger::debug()` in Godot source code.
			get_session(session_id).send_message.call_deferred("continue", [])
		else:
			_print(session_id, "Invalid parameter `from`: %s." % from)
		return true
	return false


func _setup_session(session_id: int) -> void:
	var session: EditorDebuggerSession = get_session(session_id)
	session.breaked.connect(_on_session_breaked.bind(session_id).unbind(1))


func _on_session_breaked(session_id: int) -> void:
	_print(session_id, "_on_session_breaked(): Begin")
	get_session(session_id).send_message("my_plugin:get_stack", ["session_breaked"])
	_print(session_id, "_on_session_breaked(): End")


func _print(session_id: int, data: String) -> void:
	print_rich("[color=orange][b]%d>[/b] %s[/color]" % [session_id, data])


func _print_stack(session_id: int, stack: Array) -> void:
	for frame: Dictionary in stack:
		_print(session_id, "    {source}:{line} {function}".format(frame))
