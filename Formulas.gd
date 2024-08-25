extends RefCounted
class_name Formulas


#returns the product of the attacker's attack and the action's multiplier
static func calculate_potential_damage(action_data : ActionData, attacker : Battler) -> float:
	return attacker.stats.attack * action_data.damage_multiplier
	

static func calculate_base_damage(action_data : ActionData, attacker : Battler, defender : Battler) -> int:
	var damage: float = calculate_potential_damage(action_data, attacker)
	damage -= defender.stats.defense
	damage += _calculate_weakness_multiplier(action_data, defender)
	return int(clamp(damage, 1.0, 999.0))
	
#calculates a multiplier based on the action and the defender's elements
static func _calculate_weakness_multiplier(action_data, defender) -> float:
	var multiplier : float = 1.0
	var element : int = action_data.element
	if element != Types.ELEMENTS.NONE:
		#if the defender has an affinity with the action's element
		#the multiplier should be 0.75
		if Types.WEAKNESS_MAPPING[defender.stats.affinity] == element:
			multiplier = 0.75
		#if the defender has weakness, the multiplier is 1.5
		elif Types.WEAKNESS_MAPPING[element] in defender.stats.weaknesses:
			multiplier = 1.5
	return multiplier
	
static func calculate_hit_chance(action_data : ActionData, attacker : Battler, defender : Battler) -> float:
	var chance : float = attacker.stats.hit_chance - defender.stats.evasion
	
	#the action's hit chance is a value between 0 and 100 for consistency
	#with the battlers' stats. As we use it as a multiplier here
	#we needto divide it by 100 first
	chance *= action_data.hit_chance / 100.0
	
	var element : int = action_data.element
	
	#if element == attacker.stats.affinity:
	#	chance += 5.0
	if element != Types.ELEMENTS.NONE:
		#if the action's element is part of the defender's weaknesses
		#we increase the hit rating by 10
		if Types.WEAKNESS_MAPPING[element] in defender.stats.weaknesses:
			chance += 10.0
		#if the defender has an affinity with the action's element
		#we decrease the hit rating by 10
		if Types.WEAKNESS_MAPPING[defender.stats.affinity] == element:
			chance -= 10.0
			
	return clamp(chance, 0.0, 100.0)
	
	
	
	
