extends Node
class_name StatusEffectContainer

#maximum number of instances of one type of status effect
#that can be applied to one battler at a time
const MAX_STACKS : int = 5
#list of effects that can be stucked
const STACKING_EFFECTS := ["bug"]
#List of effect that cannot be stacked. When a new effect
#of this kind is applied, it replaces or refreshes the previous one
const NON_STACKING_EFFECTS := ["haste", "slow"]

var time_scale : float = 1.0 : set = set_time_scale
var is_active : bool = true : set = set_is_active


#Adds a new instance of a status effect as a child,
#ensuring the effects don't stack past MAX_STACKS
func add(effect : StatusEffect):
	#If we already have active effects, we may have to replace one
	#If it can stack, we repalce the one with the smallest time left
	if effect.can_stack():
		if _has_maximum_stacks_of(effect.id):
			_remove_effect_expiring_the_soonest(effect.id)
	elif has_node(effect.name):
		#we call statuseffect.expire() to let the effect
		#properly clean up itself
		get_node(effect.name).expire()
	#the status effect are node so all we need to do is add it
	#as a child of the container
	add_child(effect)


func remove_type(id : String):
	for effect in get_children():
		if effect.id == id:
			effect.expire()
			

func remove_all():
	for effect in get_children():
		effect.expire()
		

func set_time_scale(value : float):
	time_scale = value
	for effect in get_children():
		effect.time_scale = time_scale
		

func set_is_active(value : bool):
	is_active = value
	for effect in get_children():
		effect.is_active = is_active
		

func _has_maximum_stacks_of(id : String) -> bool:
	var count : int = 0
	for effect in get_children():
		if effect.id == id:
			count += 1
	return count == MAX_STACKS
	
func _remove_effect_expiring_the_soonest(id : String):
	var to_remove : StatusEffect
	var smallest_time : float = INF
	#check all effects to find the ones that match the id
	for effect in get_children():
		if effect.id != id:
			continue
		#we compare the time_left for an effect of type id
		#to the current smallest_time and if it is smaller
		#we update the variables
		var time_left : float = effect.get_time_left()
		if time_left < smallest_time:
			to_remove = effect
			smallest_time = time_left
	to_remove.expire()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
