extends Action
class_name AttackAction

#calculate and store hits in array to consume later
#in sync with the animation
var _hits : Array[Hit]= []


func _init(data : AttackActionData, actor : Battler, targets : Array[Battler]):
	super._init(data, actor, targets)

#return the damage dealt by this action
func calculate_potential_damage_for(target : Battler) -> int:
	return Formulas.calculate_base_damage(_data, _actor, target)
	
func _apply_async() -> bool:
	for target in _targets:
		var hit_chance := Formulas.calculate_hit_chance(_data, _actor, target)
		var damage := calculate_potential_damage_for(target)
		var hit := Hit.new(damage, hit_chance)
		
		target.take_hit(hit)
	return true
