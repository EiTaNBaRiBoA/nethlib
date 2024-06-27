extends Node

func _ready() -> void:
	
	var test: TestJSONObject = TestJSONObject.new()
	test.color = Color(0.3, 0.3, 0.2, 0.99)
	test.vec2 = Vector2(6.0, 9.0)
	test.vec3 = Vector3(1.0, 2.0, 3.0)
	test.str = "i been srlized"
	test.str_dont_serialize = "dont seriliz me :)"
	test.iint = 55555
	test.ffloat = 9.12345678
	
	print(JSON.stringify(JSONSerialization.serialize(test)))
	
	#var tr: Test.TestRes = Test.TestRes.new()
	#tr.ffloat = 4.20
	#tr.iint = 69
	#tr.str = "hello!"
	#tr.vec2 = Vector2(1.0,2.0)
	#tr.vec3 = Vector3(4.0,5.0,6.0)
	
	#tr.sub_resource = Test.TestRes.new()
	#tr.sub_resource.ffloat = 6.9420
	#tr.sub_resource.str = "this is a nested object!"
	#
	#print("sub_resource2" in tr)
