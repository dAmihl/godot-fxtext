extends "res://addons/gdfxtext/gdfxtext_base.gd"

export var start_delay = 1.0
export var speed_stuck_multiplier = 1.8

export var character_map:Dictionary = {"S": 0.6, "T": 0.5, "M": 0.1, "ST": 0.8, "F":0.3, "C":0.2, "G":0.4, "R": 0.25, "SH":0.0}
export var max_map_chunk_size = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(start_delay), "timeout")
	yield(self, "text_finished")
	pass
	
func init_gdfxtexts():
	self.CustomLabel = preload("res://examples/stutter/damped_spring_label.gd")
	pass
	
	
func modify_word(word:String) -> String:
	
	var current_length = self.max_map_chunk_size
	var resulting_word = word
	
	while current_length > 0:
		var current_chunk = word.substr(0,current_length)

		var current_chunk_caps = current_chunk.to_upper()
	
		var remaining_word = word.substr(current_length, word.length())
		
		var chance = 0
		if self.character_map.has(current_chunk_caps):
			chance = self.character_map.get(current_chunk_caps)
			if (chance == 0.0):
				current_length -= 1
				continue
			
		randomize()
		var roll = rand_range(0.0, 1.0)

		if (roll >= (1.0 - chance)):
			randomize()
			var roll_type = rand_range(0.0, 1.0)
			var intensity = floor(abs((roll - chance) * 10))
			if (roll_type >= 0.5):
				resulting_word = self.modify_stuck_word_repeating(current_chunk, remaining_word, intensity)
			else:
				resulting_word = self.modify_stuck_word_block(current_chunk, remaining_word, intensity)
			break
		
		current_length -= 1
	
	return resulting_word

func check_apply_effect(var original_string:String, var modified_string: String):
	var print_mode = original_string == modified_string
	if not print_mode:
		self.speed_modifier = self.speed_stuck_multiplier
	else:
		self.speed_modifier = self.speed_base
	return print_mode


func modify_stuck_word_repeating(repeating_chunk:String, remaining_word:String, intensity:int = 2) -> String:
	var last_character = repeating_chunk.substr(0, repeating_chunk.length())
	var repeated_chunk = ""
# warning-ignore:unused_variable
	for i in range(intensity):
		repeated_chunk += last_character+"-"
		
	var modified = repeated_chunk + repeating_chunk +  remaining_word
	return modified

func modify_stuck_word_block(blocking_chunk:String, remaining_word:String, intensity:int = 2) -> String:
	var blocking_text = ""
# warning-ignore:unused_variable
	for i in range(intensity):
		blocking_text += "."
		if intensity == 1:
			blocking_text += "."
	var modified = blocking_chunk + blocking_text + remaining_word
	return modified

