## Data class that represents a seperate instance of an [AttributeEffect] 
## which was (or can be) applied to an [Attribute].
class_name AttributeEffectSpec extends Resource

## Used in [method Array.custom_sort] to sort specs in a reverse order.
static func reverse_compare(a: AttributeEffectSpec, b: AttributeEffectSpec) -> bool:
	var a_override: bool = a.is_override()
	var b_override: bool = b.is_override()
	
	if a_override && b_override:
		return a._effect.override_priority < b._effect.override_priority
	elif a_override:
		return false
	else:
		return true

## The effect this [AttributeEffectSpec] was created for.
var _effect: AttributeEffect

## The current stack count
var _stack_count: int

## If true, duration is ticking (if the [AttributeEffect] has a duration).
var tick_duration: bool = true

## The initial duration of the effect.
var _starting_duration: float

## The remaining duration in seconds, can not be set to less than 0.0.
var remaining_duration: float:
	set(_value):
		remaining_duration = max(0.0, _value)

## If this spec is actively applied to an [Attribute].
var _is_applied: bool = false

## Amount of times the [AttributeEffect] was applied to the [Attribute].
var _apply_count: int = 0

## The condition that lasts denied application of this spec.
var _denied_by: AttributeEffectCondition

## The last frame this spec was processed on.
var _last_process_frame: int = -1

## Whether or not this spec expired.
var _expired: bool = false

## The remaining amount of time, in seconds, until this effect is next triggered.
## Can be manually set before applying to an [AttributeEffect] to create an initial
## delay in if it is applied.
var remaining_period: float = 0.0

func _init(effect: AttributeEffect, stack_count: int = 1) -> void:
	assert(effect != null, "effect is null")
	assert(stack_count > 0, "stack_count is > 0")
	assert(stack_count < 2 || effect.stack_mode == AttributeEffect.StackMode.COMBINE,
	"stack_count >= 2 but stack_mode = false for effect: (%s)" % effect)
	_effect = effect
	_stack_count = stack_count
	# TODO calculate starting duration
	# TODO calculate 


## Returns the [AttributeEffect] instance this spec was created for.
func get_effect() -> AttributeEffect:
	return _effect


## Shorthand function that returns true [method get_effect] has a 
## [member Attribute.duration_type] of [enum AttributeEffect.DurationType.INSTANT].
func is_instant() -> bool:
	return _effect.duration_type == AttributeEffect.DurationType.INSTANT


## Shorthand function that returns true [method get_effect] has a 
## [member Attribute.duration_type] of [enum AttributeEffect.DurationType.HAS_DURATION].
func has_duration() -> bool:
	return _effect.duration_type == AttributeEffect.DurationType.HAS_DURATION


## Returns true if this spec is currently applied to an [Attribute].
func is_applied() -> bool:
	return _is_applied


## Returns true if the [AttributeEffect] is currently processing on an [Attribute],
## or false if it not currently applied to an [Attribute] (see [method is_applied])
## or was last blocked by an [AttributeEffectCondition] (see [method get_denied_by]).
func is_processing() -> bool:
	return _is_applied && _denied_by == null


## Returns the last process frame this spec was processed on.
func get_last_process_frame() -> int:
	return _last_process_frame


## Returns true if [member effect] has a [member AttributeEffect.value_calc_type]
## equal to [enum AttributeEffect.ValueCalcType.OVERRIDE]
func is_override() -> bool:
	return _effect.value_cacl_type == AttributeEffect.ValueCalcType.OVERRIDE


## If currently denied, returns the [AttributeEffectCondition] that denied this spec.
## Otherwise returns null.
func get_denied_by() -> AttributeEffectCondition:
	return _denied_by


## Returns the initial duration of the effect when it was first applied.
func get_starting_duration() -> float:
	return _starting_duration


## Amount of times this [AttributeEffectSpec] was applied to an [Attribute].
func get_apply_count() -> int:
	return _apply_count


## Returns true if the effect expired due to duration, false if not. Can be useful
## to see if this spec was manually removed from an [Attribute] or if it expired.
func expired() -> bool:
	return _expired


## TODO
func can_add(attribute: Attribute) -> AttributeEffectCondition:
	for condition: AttributeEffectCondition in _effect.conditions:
		if condition.block_add && !condition._meets_condition(attribute, self):
			return condition
	
	return null


## TODO
func can_apply(attribute: Attribute) -> AttributeEffectCondition:
	for condition: AttributeEffectCondition in _effect.conditions:
		if condition.block_apply && !condition._meets_condition(attribute, self):
			return condition
	
	return null


## Calculates the value to be used at the current frame.
func calculate_value(attribute: Attribute) -> float:
	return _effect._calculate_value(attribute, self)


func stack(attribute: Attribute, add_amount: int = 1) -> void:
	assert(add_amount > 0, "add_amount (%s) <= 0" % add_amount)
	assert(_effect.stack_mode == AttributeEffect.StackMode.COMBINE, 
	"_effec.stack_mode != COMBINE")
	
	_stack_count += add_amount
	if _effect.value_stack_mode == AttributeEffect.ValueStackMode.ADD:
		pass
	
	if _effect.duration_stack_mode == AttributeEffect.DurationStackMode.RESET:
		pass
	elif _effect.duration_stack_mode == AttributeEffect.DurationStackMode.ADD:
		pass


## Processes this spec on the [param attribute], returning true if it should
## remain applied, false if not.
func process(attribute: Attribute, delta: float, process_frame: int) -> bool:
	if is_instant():
		_last_process_frame = process_frame
		
		pass
	
	# Ensure it isn't already processed this frame if not instant (can be applied
	# multiple times in an instant)
	if !instant && _last_process_frame == process_frame:
		return true
	
	if instant:
		_apply(attribute, delta, process_frame)
		pass
	
	var _has_duration: bool = has_duration()
	
	# If remaining duration is already <= 0, it should be removed and not processed.
	if _has_duration && remaining_duration <= 0:
		return false
		
	if remaining_period
	
	# PERIOD 
	
	if _has_duration:
		pass
	
	return false


func _period(attribute: Attribute, delta: float, process_frame: ind) -> void:
	pass


func _apply(attribute: Attribute, delta: float, process_frame: int) -> void:
	pass


func _to_string() -> String:
	return "AttributeEffectSpec(_effect.id:%s)" % _effect.id
