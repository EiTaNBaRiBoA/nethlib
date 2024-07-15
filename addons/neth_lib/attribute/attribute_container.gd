## Container node for [Attribute]s allowing siblings to communicate with each other
## by searching this container for [member Attribute.id].
@tool
class_name AttributeContainer extends Node

signal attribute_added(attribute: Attribute)

signal attribute_removed(attribute: Attribute)

signal tag_added(tag: StringName)

signal tag_removed(tag: StringName)

## Tags to be added to the internal _tags [Dictionary] in _ready.
@export var default_tags: PackedStringArray

var _attributes: Dictionary = {}
var _tags: Dictionary = {}

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	child_entered_tree.connect(_on_child_entered_tree)


func _ready() -> void:
	for tag: String in default_tags:
		add_tag(StringName(tag))


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return
	child_entered_tree.disconnect(_on_child_entered_tree)
	_attributes.clear()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()
	var ids: PackedStringArray = PackedStringArray()
	
	for child: Node in get_children():
		if child is Attribute:
			if child.id.is_empty():
				warnings.append("Child (%s) has no ID set" % child.name)
				continue
			if ids.has(child.id):
				warnings.append("Attributes with duplicate ids found (%s)" % child.id)
			else:
				ids.append(child.id)
		else:
			warnings.append("child (%s) not of type Attribute" % child.name)
	
	if ids.is_empty():
		warnings.append("No valid Attribute children found")
	
	return warnings


func has_attribute_id(id: StringName) -> void:
	return _attributes.has(id)


## Returns the [Attribute] with the specified [member id].
func get_attribute(id: StringName) -> Attribute:
	return _attributes.get(id).get_ref()


## Adds the [param tag], returning true if added, false if not as it already existed.
func add_tag(tag: StringName) -> bool:
	assert(!tag.is_empty(), "tag is empty")
	if has_tag(tag):
		return false
	_tags[tag] = null
	tag_added.emit(tag)
	return true


## Returns true if the [param] tag exists on this container, false if not.
func has_tag(tag: StringName) -> bool:
	return _tags.has(tag)


## Removes the [param tag], retunrs true if it existed & was removed, false if not.
func remove_tag(tag: StringName) -> bool:
	if _tags.erase(tag):
		tag_removed.emit(tag)
		return true
	return false


func _on_child_entered_tree(child: Node) -> void:
	if child is Attribute:
		assert(!child.id.is_empty(), "child (%s)'s id is empty" % child.name)
		assert(!_attributes.has(child.id), "duplicate Attribute ids found (%s)" % child.id)
		_attributes[child.id] = weakref(child)


func _on_child_exited_tree(child: Node) -> void:
	if child is Attribute:
		_attributes.erase(child.id)
