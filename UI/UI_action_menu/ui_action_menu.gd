extends Control
class_name UI_action_menu


signal action_selected

const UI_action_list := preload("res://UI/UI_action_menu/ui_action_list.tscn")

@onready var name_label : Label = $name_label

var _battler : Battler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Replace with function body.


func open(battler : Battler):
	_battler = battler
	var list = UI_action_list.instantiate()
	add_child(list)
	
	list.action_selected.connect(_on_UI_action_list_action_selected)
	list.setup(battler)
	
	name_label.text = battler.get_id()
	show()
	#calling the list focus allows the first button to grab focus 
	list.focus()
	
	
func close():
	hide()
	
func _on_UI_action_list_action_selected(action : ActionData):
	_battler.action_selected.emit(action)
	close()
