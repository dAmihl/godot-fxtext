tool
extends EditorPlugin

const gdFxTextsBase = preload("res://addons/gdfxtexts/gdfxtexts_base.gd")

var base : Node

func _enter_tree():
	base = gdFxTextsBase.new()
	add_child(base)
	pass

func _exit_tree():
	remove_child(base)
	pass