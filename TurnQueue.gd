extends Node
class_name TurnQueue


#emitted when a player-controlled battler finished playing a turn
signal player_turn_finished

#if true the player is currently playing a turn
var _is_player_playing : bool = false
#stack of player-controlled battlers that have to take turns
var _queue_player : Array[Battler] = []


var _party_members : Array = []
var _opponents : Array = []

#allows pausing the turn queue when needed
var is_active : bool = true : set = set_is_active
#multiplier for the global pace of battle, to slow down time while the player
#is making decisions. This is meant for accessibility and to control
#difficulty
var time_scale : float = 1.0 : set = set_time_scale

@onready var battlers : Array = self.get_children()


func set_is_active(value : bool ) -> void:
	is_active = value
	for battler in battlers:
		battler.is_active = is_active
		
func set_time_scale(value : float):
	time_scale = value
	for battler in battlers:
		battler.time_scale = time_scale
		

# Called when the node enters the scene tree for the first time.
func _ready():
	player_turn_finished.connect(_on_player_turn_finished)
	for battler in battlers:
		#listen to each battler's ready_to_act signal
		#binding a reference to the battler
		#to the callback
		battler.ready_to_act.connect(_on_Battler_ready_to_act)
		if battler.is_party_member:
			_party_members.append(battler)
		else:
			_opponents.append(battler)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Battler_ready_to_act(battler : Battler):
	#if the battler is controlled by the player but another 
	#player-controlled battler is in the middle of a turn
	#we add this one to the queue
	if battler.is_player_controlled() and _is_player_playing:
		_queue_player.append(battler)
	else:
		_play_turn(battler)
	
func _play_turn(battler : Battler):
	var action_data : ActionData
	var targets : Array[Battler] = []
	
	battler.stats.energy += 1
	battler.is_selected = true
	
	var potential_targets := []
	var opponents : Array = _opponents if battler.is_party_member else _party_members
	for opponent in opponents:
		if opponent.is_selectable:
			potential_targets.append(opponent)
		
	if battler.is_player_controlled():
		battler.is_selected = true
		set_time_scale(0.05)
		_is_player_playing = true
		
		var is_selection_complete := false
		while not is_selection_complete:
			action_data = await _player_select_action_async(battler)
			if action_data.is_targeting_self:
				targets = [battler]
			else: 
				targets = await _player_select_targets_async(action_data, potential_targets)
			is_selection_complete = action_data != null && targets != []
		set_time_scale(1.0)
		battler.is_selected = false
	else:
		action_data = battler.actions[0].get_action_data()
		targets = [potential_targets[0]]
	
	var action = AttackAction.new(action_data, battler, targets)
	battler.act(action)
	await battler.action_finished
	
	if battler.is_player_controlled():
		player_turn_finished.emit()

func _player_select_action_async(battler : Battler) -> ActionData:
	await battler.current_action_selected
	return battler.current_action.get_action_data()
	
func _player_select_targets_async(_action : ActionData, opponents : Array[Battler]) -> Array[Battler]:
	await battler.targets_selected
	return battler.get_targets()
	
func _on_player_turn_finished():
	if _queue_player.is_empty():
		_is_player_playing = false
	else:
		_play_turn(_queue_player.pop_front())
		
