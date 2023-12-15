extends Control

class_name UITextureStore


func get_scoop(p_name: String) -> CompressedTexture2D:
	return get_node("Scoop%s" % p_name.capitalize()).texture


func get_dish(p_name: String) -> TextureRect:
	return get_node("Dish%s" % p_name.capitalize())
