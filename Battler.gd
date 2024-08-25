extends Node2D
class_name Battler


#emitted when the battler is ready to take a turn
signal ready_to_act
#emitted when the battler's _readiness changes
signal readines_changed(new_value)
#emitted when modifying is_selected property.
#the user interface will react to this for player-controlled battler
signal selection_toggled(value)
#emitted when taking damage
signal damage_taken(amount : int)
#emitted when hit missed
signal hit_missed
#emitted when action is selected
signal action_selected(action : ActionData)
#emitted when the battler finish their actions
signal action_finished
#emitted when targets selected
signal targets_selected

@export var id : String : get = get_id
@export var stats : BattlerStats
@export var ai_scene : PackedScene
#each element of the array represents an action
#that the Battler can perform

@export var actions : Array

var targets : Array[Battler] : set = set_targets

@export var is_party_member : bool = false
@export var is_enemy : bool = false

@onready var turn_queue := get_parent()

# the turn queue will change this property when another battler is acting
var time_scale := 1.0: set = set_time_scale
# when this value reaches 100.0 the battler is ready to act
var _readiness := 0.0: set = _set_readiness

var is_active : bool = true: set = set_is_active
#if true the battler is selected
var is_selected : bool = false : set = set_is_selected
#if false the battler cannot be targeted by any action
var is_selectable : bool = true : set = set_is_selectable


func get_id() -> String:
	return id
	
func set_time_scale(value):
	time_scale = value
	
func _set_readiness(value):
	_readiness = value
	readines_changed.emit(_readiness)
	
	if _readiness >= 100.0:
		ready_to_act.emit()
		EventBus.publish("battler_ready_to_act", id)
		#when the battler is ready, stop the process
		#so prevent _process from triggering another call
		#to this function
		set_process(false)

func set_is_active(value):
	is_active = value
	set_process(true)
	
func set_is_selected(value):
	if value:
		assert(is_selectable)
	is_selected = value
	selection_toggled.emit(is_selected)
	
func set_is_selectable(value):
	is_selectable = value
	if not is_selectable:
		set_is_selectable(value)
		
func is_player_controlled() -> bool:
	return !is_enemy
	
func get_targets() -> Array[Battler]:
	return targets
	
func set_targets(value : Array[Battler]):
	targets = value
	targets_selected.emit()
	


# Called when the node enters the scene tree for the first time.
func _ready():
	stats = stats.duplicate()
	stats.reinitialize()
	stats.health_depleted.connect(_on_BattlerStats_health_depleted) # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	_set_readiness(_readiness + stats.speed * delta )
	pass
	

func _on_BattlerStats_health_depleted():
	#when the health depletes, we turn off processing for this battler
	set_is_active(false)
	#if it is a opponent we mark it as unselectable.
	#for party member you still want to be able to select them
	#to revive themS
	if not is_party_member:
		set_is_selectable(false)
		
#applies a hit object to the battler, dealing damage or status effect
func take_hit(hit : Hit):
	if hit.does_hit():
		_take_damage(hit._damage)
		damage_taken.emit(hit._damage)
	else:
		hit_missed.emit()
		
func _take_damage(amount : int):
	stats.health -= amount
	print("%s took %s damage. Health is now %s." % [name, amount, stats.health])
	
func _get_potential_targets() -> Array[Battler]:
	var potential_targets : Array[Battler]
	var opponents : Array
	if is_party_member:
		opponents = turn_queue.get_opponents()
	else:
		opponents = turn_queue.get_party()
		
	for opponent in opponents:
		if opponent.is_selectable:
			potential_targets.append(opponent)
	
	return potential_targets

func act():
#var action_data : ActionData
	#var targets : Array[Battler] = []
	#
	#battler.stats.energy += 1
	#battler.is_selected = true
	#
	var targets : Array[Battler] = []
	var potential_targets := _get_potential_targets()
	
	var action_data : ActionData
	if is_player_controlled():
		is_selected = true
		#set_time_scale(0.05)
		#_is_player_playing = true
		#
		var is_selection_complete := false
		action_data = await action_selected
			#if action_data.is_targeting_self:
			#	targets = [battler]
			#else: 
			#	targets = await _player_select_targets_async(action_data, potential_targets)
			#is_selection_complete = action_data != null && targets != []
		#set_time_scale(1.0)
		targets.append(potential_targets[0])
		is_selected = false
	else:
		action_data = actions[0]
		targets.append(potential_targets[0])
	#
	var action = AttackAction.new(action_data, self, targets)
	
	#await battler.action_finished
	#
	#if battler.is_player_controlled():
		#player_turn_finished.emit()
		
	
	#if the action costs energy we subtract it
	stats.energy -= action.get_energy_cost()
	
	await action.apply_async()
	#reset the _readiness
	#the value can be greater than zero, depending on the action
	_set_readiness(action.get_readiness_saved())
	
	if is_active:
		set_process(true)
		
	action_finished.emit()
	
func take_turn():
	ready_to_act.emit()
	EventBus.publish("battler_ready_to_act", id)
	await act()
	
