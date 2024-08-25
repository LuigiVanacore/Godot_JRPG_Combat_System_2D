extends TextureButton

@onready var _icon : TextureRect = $HBoxContainer/Icon
@onready var _label : Label = $HBoxContainer/Label

#to call from a parent UI widget. Initializes the button
func setup( action : ActionData, can_be_used : bool):
	#In a parent node you may call setup() before adding the button
	#as a child
	#if that is the case, we need to pause the execution until
	#the button is ready
	if not is_inside_tree():
		await ready
	#update the icon's texture only if the action data include icon
	if action.icon:
		_icon.texture = action.icon
	_label.text = action.label
	
	disabled = not can_be_used
	
#When pressing the button, release its focus
#Doing this prevents the player from pressing two action buttons
#or from pressing one twice
func _on_pressed():
	release_focus()
