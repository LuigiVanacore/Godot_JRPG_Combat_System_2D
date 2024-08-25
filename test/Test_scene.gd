extends Node2D

@onready var player : Battler = $ActiveTurnQueue/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.subriscribe(self, "player_attack", player_attack) # Replace with function body.
	EventBus.subriscribe(self, "battler_ready_to_act", show_action_menu)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_attack():
	pass

func show_action_menu(id : String):
	if id == "player":
		var ui_action_menu := $CanvasLayer/Test_UI/UI_action_menu
		ui_action_menu.open(player)
