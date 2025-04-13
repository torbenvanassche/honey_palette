@tool
extends EditorScenePostImport

var material: ShaderMaterial = preload("res://materials/color_filter/color_filter_cybercity_02_A.tres")

func _post_import(scene: Node) -> Object:
	scene.get_children()[0].set_surface_override_material(0, material)
	return scene 
