extends Node


func _ready() -> void:
	print("_ready(): Before test")
	Test.test()
	print("_ready(): Before breakpoint 1")
	breakpoint
	print("_ready(): Before breakpoint 2")
	breakpoint
	print("_ready(): End")
