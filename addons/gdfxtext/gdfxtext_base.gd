extends Node2D

export var starting_pos:Vector2 = Vector2(0,0)
export var speed_base = 0.1
export var font: Font = null
export var max_width = 800
export var line_height_spacing = 1
export var text = "The game engine you waited for. Godot provides a huge set of common tools, so you can just focus on making your game without reinventing the wheel. Godot is completely free and open-source under the very permissive MIT license. No strings attached, no royalties, nothing. Your game is yours, down to the last line of engine code."

var speed_modifier = 1
var last_pos:Vector2 = starting_pos

signal word_finished
signal chunk_finished
signal text_finished

var CustomLabel = Label

func _ready():
	set_physics_process(false)

	if not is_instance_valid(self.font):
		var l = Label.new()
		font = l.get_font("font")

	init_gdfxtexts()
	self.last_pos = self.starting_pos
	self._processText(text)
	pass 

func init_gdfxtexts():
	pass

func modify_word(var word:String) -> String:
	return word

func check_apply_effect(var original_word:String, var modified_word:String) -> bool:
	return false


func _processText(text:String):
	var chunks = _calculate_chunks(text)
	for l in chunks:
		self._printChunk(l)
	yield(self, "text_finished")
	pass
	
func _printChunk(chunk: Array):
	
	for w in chunk:
		
		var current_x = self.last_pos.x
		var apply_effect = false
		var modified_word = modify_word(w)
		
		apply_effect = check_apply_effect(w, modified_word)
		
		var word_with_space:String = modified_word+" "	
		var next_chunk_size = self.font.get_string_size(word_with_space)
		
		if current_x + next_chunk_size.x > self.max_width:
			#next line
			var line_height = next_chunk_size.y
			self.last_pos.y += line_height + self.line_height_spacing
			self.last_pos.x = self.starting_pos.x
		
		self._printString(word_with_space, apply_effect)
		yield(self, "word_finished")
	
	self.emit_signal("chunk_finished")
	pass

func _calculate_chunks(text:String):
	var all_words: PoolStringArray = text.split(" ") 
	var chunks: Array = []
	chunks.append(all_words)
	return chunks

func _printString(word:String, single_label:bool=false):
	if single_label:
		_printStringAsSingleLabel(word, last_pos)
	else:
		_printStringAsMultipleLabels(word)
	

func _printStringAsMultipleLabels(word:String):
	var spacing = 0
	for c in word:
		spacing = _printCharacterAsLabel(c, self.last_pos)
		var new_pos = Vector2(self.last_pos.x + spacing.x, self.last_pos.y)
		self.last_pos = new_pos
		yield(get_tree().create_timer(speed_base * speed_modifier), "timeout")
	self.emit_signal("word_finished")

func _printStringAsSingleLabel(word:String, pos:Vector2):
	var l = Label.new()
	l.rect_position.x = pos.x
	l.rect_position.y = pos.y
	l.add_font_override("font", self.font)
	add_child(l)
	for c in word:
		l.text += c
		yield(get_tree().create_timer(speed_base), "timeout")
	var spacing = self.font.get_string_size(word)
	var new_pos = Vector2(self.last_pos.x + spacing.x, self.last_pos.y)
	self.last_pos = new_pos
	self.emit_signal("word_finished")


func _printCharacterAsLabel(character:String, pos:Vector2):
	var l = CustomLabel.new()
	l.text = character
	l.rect_position.x = pos.x
	l.rect_position.y = pos.y
	l.add_font_override("font", self.font)
	add_child(l)
	var printed_size = self.font.get_string_size(character)
	return printed_size