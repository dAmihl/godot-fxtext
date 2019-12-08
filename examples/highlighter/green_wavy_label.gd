extends Label

var original_pos:Vector2
var offset = 0.0
var deltaCumulation = 0.0
var max_amplitude = 2
var current_amplitude = max_amplitude
var frequency = 7
var dampening = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	original_pos = rect_position
	add_color_override("font_color", Color(0,1,0))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltaCumulation += delta
	current_amplitude = clamp(max_amplitude - deltaCumulation/5, 0, max_amplitude)
	deltaCumulation = fmod(deltaCumulation, 2*PI)
	offset = sin(frequency * deltaCumulation) * current_amplitude
	rect_position.y = original_pos.y + offset
	pass
