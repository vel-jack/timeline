extends TextureRect


var num = 0 setget set_num

func set_num(n):
	num = n
	$Label.text = str(n)
