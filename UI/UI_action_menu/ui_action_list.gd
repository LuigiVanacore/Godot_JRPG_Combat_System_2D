extends VBoxContainer

#emitted when the player press the action button
signal action_selected(action)

#instantiate an action button for each action of the battler
const UI_action_button : PackedScene = preload("res://UI/UI_action_menu/UI_action_button.tscn")
#toggles all children buttons disabled
var is_disabled : bool = false : set = set_is_disabled

var buttons := []

@onready var _select_arrow := $UiMenuSelectionArrow


func setup(battler : Battler):
	for action in battler.actions:
		var can_use_action : bool = battler.stats.energy >= action.energy_cost
		#instantiate a button and call its setup fuction
		var action_button = UI_action_button.instantiate()
		add_child(action_button)
		action_button.setup(action, can_use_action)
		
		action_button.pressed.connect(_on_UIActionButton_button_pressed.bind(action))
		action_button.focus_entered.connect(_on_UIActionButton_focus_entered.bind(action_button,battler.get_id(),action.energy_cost))
		buttons.append(action_button)
	#centers the arrow vertically wit the first button
	#and place it on its left
	_select_arrow.position = (buttons[0].global_position + Vector2(0.0, buttons[0].size.y / 2.0))
	
	
func focus():
	buttons[0].grab_focus()
	
func set_is_disabled(value : bool):
	is_disabled = value
	for button in buttons:
		button.disabled = is_disabled
		
func _on_UIActionButton_button_pressed(action : ActionData):
	set_is_disabled(true)
	action_selected.emit(action)
	
func _on_UIActionButton_focus_entered(button : TextureButton, battler_display_name : String, energy_cost : int):
	_select_arrow.move_to(button.global_position + Vector2(0.0, button.size.y / 2.0))
