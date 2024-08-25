extends Control


@onready var text_label := $RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	text_label.add_text("Test Started \n") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func write_text(text : String):
	text_label.add_text(text)
