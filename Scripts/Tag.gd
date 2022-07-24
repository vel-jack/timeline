extends TextureButton


var num = 0 setget set_num
var at = 0

func set_num(n):
	num = n
	$Tag/Label.text =str(n)

func _on_Tag_pressed():
# warning-ignore:return_value_discarded
	Tags.tags.erase(at)
	queue_free()
