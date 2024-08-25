extends Control

@onready var UI_History := $UI_History
# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.subriscribe(self, "battler_ready_to_act", _print_battler_ready_to_act) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _print_battler_ready_to_act(value):
	UI_History.write_text(value + " ready to act \n")


func _on_button_pressed():
	EventBus.publish("player_attack", null) # Replace with function body.


func _on_start_button_pressed() -> void:
	EventBus.publish("start_battle", null)
