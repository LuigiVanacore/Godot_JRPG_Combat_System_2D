extends RefCounted
class_name StatusEffectBuilder


const StatusEffects := {
	haste = StatusEffectHaste,
	slow = StatusEffectSlow,
	bug = StatusEffectBug,
}

static func create_status_effect(target : Battler, data):
	if not data:
		return null
	var effect_class = StatusEffects[data.effect]
	var effect : StatusEffect = effect_class.new(target, data)
	return effect






































# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
