## Modifies a value based on the current stack count of an [AttributeEffectSpec].
class_name StackModifier extends AttributeEffectModifier

enum Mode {
	## Multiplies the value by the stack count
	MULTIPLY_BY_STACK,
	## Divides the value by the stack count
	DIVIDE_BY_STACK,
	## Raises the value to the power of the stack count.
	TO_POWER_OF_STACK,
}

## The [enum Mode] to be used.
@export var mode: Mode


func _validate_and_assert(effect: AttributeEffect) -> void:
	assert(effect.stack_mode == AttributeEffect.StackMode.COMBINE, 
	"stack_mode != COMBINE for effect: %s" % effect)


func _modify(current_modified: float, attribute: Attribute, spec: AttributeEffectSpec) -> float:
	assert(spec._effect.stack_mode == AttributeEffect.StackMode.COMBINE,
	"stack_mode != COMBINE for spec._effect: %s" % spec._effect)
	
	match mode:
		Mode.MULTIPLY_BY_STACK:
			return current_modified * spec.get_stack_count()
		Mode.DIVIDE_BY_STACK:
			return current_modified / spec.get_stack_count()
		Mode.TO_POWER_OF_STACK:
			return pow(current_modified, spec.get_stack_count())
		_:
			assert(false, "no logic written for mode: %s" % mode)
			return current_modified
