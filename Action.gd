extends RefCounted
class_name Action


signal finished

@export var _data : ActionData : get = get_action_data
var _actor : Battler
var _targets : Array[Battler] = []


func _init(data : ActionData, actor : Battler, targets : Array[Battler]):
	_data = data
	_actor = actor
	_targets = targets
	
func apply_async() -> bool:
	return await _apply_async()
	
func _apply_async() -> bool:
	finished.emit()
	return true
	
func targets_opponents() -> bool:
	return true
	
func get_readiness_saved() -> float:
	return _data.readiness_saved
	
func get_energy_cost() -> int:
	return _data.energy_cost
	
func get_action_data() -> ActionData:
	return _data
