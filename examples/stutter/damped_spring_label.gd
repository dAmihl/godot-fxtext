extends Label

var original_pos:Vector2
var offset = 0.0
var deltaCumulation = 0.0
var amplitude = 0.7
var frequency = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	original_pos = rect_position
	add_color_override("font_color", Color(1,0,0))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltaCumulation += delta
	self.amplitude = clamp(self.amplitude - delta/10, 0, self.amplitude)
	deltaCumulation = fmod(deltaCumulation, 2*PI)
	offset = sin(frequency * deltaCumulation) * self.amplitude
	rect_position.y = original_pos.y + offset
	pass
