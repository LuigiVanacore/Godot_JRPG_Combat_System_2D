extends Resource
class_name ActionData

@export var icon : Texture
@export var label : String = "Base Combat action"

@export var energy_cost : int = 0
@export var element : Types.ELEMENTS = Types.ELEMENTS.NONE

@export var is_targeting_self : bool = false
@export var is_targeting_all : bool = false

#the amount of readiness left to the battler after acting
#you can use it to design weak attacks that allow you to take turn fast
@export var readiness_saved : float = 0.0

#return true if the battler has enough energy to use the action
func can_be_used_by(battler : Battler) -> bool:
	return energy_cost <= battler.stats.energy
