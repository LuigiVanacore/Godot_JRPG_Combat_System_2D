extends StatusEffect
class_name StatusEffectBug

var damage : int = 3


func _init(target : Battler, data : StatusEffectData):
	id = "bug"
	damage = data.ticking_damage
	_can_stack = true
	
	
func _apply():
	_target.take_hit(Hit.new(damage))
