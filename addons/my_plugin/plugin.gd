@tool
extends EditorPlugin


const DebuggerPlugin = preload("./debugger_plugin.gd")

var _debugger_plugin: DebuggerPlugin = DebuggerPlugin.new()


func _enter_tree() -> void:
	add_debugger_plugin(_debugger_plugin)


func _exit_tree() -> void:
	remove_debugger_plugin(_debugger_plugin)
