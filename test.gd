extends Node


func _ready() -> void:
	if EngineDebugger.is_active():
		EngineDebugger.register_message_capture("my_plugin", _capture)


func test() -> void:
	if not EngineDebugger.is_active():
		return

	print("_test(): Begin")
	EngineDebugger.send_message("my_plugin:test", get_stack())
	print("_test(): End")


func _capture(message: String, data: Array) -> bool:
	if message == "get_stack":
		# You can execute code in a running project even when the debugger is stopped.
		# The call stack at the breakpoint will be saved, and a new frame (the current call)
		# will be added to it.
		print("_capture(): get_stack: Begin")
		var from: String = data[0]
		var stack: Array = get_stack()
		stack.remove_at(0) # Remove current frame (`_capture()` call) from the stack.
		EngineDebugger.send_message("my_plugin:receive_stack", [from, stack])
		print("_capture(): get_stack: End")
		return true
	return false
