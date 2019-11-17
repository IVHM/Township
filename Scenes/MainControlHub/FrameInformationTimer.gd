extends Timer

export (int, FLAGS, "FPS", "Static Mem", "Dynamic Mem", "Object Cnt", "Texture Mem") var output_flags = 0
var NUM_FLAGS = 5
var MB = 1000000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FrameInformationTimer_timeout():
	if output_flags & 16:
		print("Frames per sec   : ", Performance.get_monitor(Performance.TIME_FPS))
	if output_flags & 1:
		print("Texture Mem Used : ", int(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)) / MB, "mb")
	if output_flags & 2:
		print("Num of objects   : ", Performance.get_monitor(Performance.OBJECT_COUNT))
	if output_flags & 4:
		print("Dynamic Mem Used : ", int(Performance.get_monitor(Performance.MEMORY_DYNAMIC)) / MB, "mb")	
	if output_flags & 8:
		print("Static Mem Used  : ", int(Performance.get_monitor(Performance.MEMORY_STATIC)) / MB, "mb")
	