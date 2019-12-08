extends "res://addons/gdfxtexts/gdfxtexts_base.gd"

export var start_delay = 1.0

export var highlight_words = ["Godot", "engine", "you", "godot"]

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(start_delay), "timeout")
	yield(self, "text_finished")
	pass
	
func init_gdfxtexts():
	self.max_width = 400
	self.CustomLabel = preload("res://examples/highlighter/green_wavy_label.gd")
	pass
	
	
func modify_word(word:String) -> String:
	var resulting_word = word
	if self.highlight_words.has(word.strip_edges(true,true)):
		resulting_word = "+++"+word+"+++"
	return resulting_word

func check_apply_effect(var original_string:String, var modified_string: String):
	original_string = original_string.strip_edges(true, true)
	return not self.highlight_words.has(original_string)