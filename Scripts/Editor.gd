extends Control

# variables
var playing = false
var cur_pos = 0
var audio_length_str = ""
var audio_length= 0


# onready 
onready var progress = $Vbox/ControllerUI/VBoxContainer/Editor/progress
onready var play = $Vbox/ControllerUI/VBoxContainer/slider/Play
onready var stop = $Vbox/ControllerUI/VBoxContainer/slider/Stop
onready var time = $Vbox/ControllerUI/VBoxContainer/slider/time
onready var audio_player = $AudioPlayer
onready var timeline = $Vbox/ControllerUI/VBoxContainer/Editor/Control/Timeline
onready var timeline_bg =$Vbox/ControllerUI/VBoxContainer/Editor/Control/TimelineBg
onready var tags_parent = $Vbox/ControllerUI/VBoxContainer/Editor/Control/TimelineBg/Tags
onready var body = $Vbox/VideoUI/body
onready var eyes = $Vbox/VideoUI/eyes

# preload
const _tag_scene = preload("res://Scenes/Tag.tscn")

func _ready():
	audio_player.stream = load("res://Assets/cool.mp3")
	audio_length = audio_player.stream.get_length()
	progress.max_value = audio_length
	audio_length_str = to_time(int(audio_length))
	set_time(0)
	set_timeline(0)
	


func set_time(t):
	time.text = to_time(t)+'/'+audio_length_str;

func set_timeline(a):
	timeline.rect_size = Vector2(timeline_bg.rect_size.x* (a/audio_length*100)/100 ,10)
	progress.value = a
	var x = int(timeline.rect_size.x)
	if x in Tags.tags.keys():
		body.frame = Tags.tags[x]['body']
		eyes.play(Tags.tags[x]['eye'])

func to_time(secs):
	return "%02d:%02d" % [(secs/60)%60,secs%60]

# warning-ignore:unused_argument
func _process(delta):
	if audio_player.playing:
		var a = audio_player.get_playback_position()
		set_time(int(a))
		set_timeline(a)
	pass


func _on_Open_pressed():
	$Openfile.visible = true
	pass # Replace with function body.


func _on_openfile_file_selected(path):
	print(path)
	
	#$AudioPlayer.stream = load(path)
	#print(path)



func _on_Play_pressed():
	if playing:
		cur_pos = $AudioPlayer.get_playback_position()
		playing = !playing
		audio_player.playing = false
		play.text = 'PLAY'
	else:
		audio_player.play(cur_pos)
		play.text = 'PAUSE'
		playing = !playing

func _on_Stop_pressed():
	if playing:
		audio_player.stop()
		progress.value = 0
		playing = !playing
		cur_pos = 0
	if cur_pos != 0:
		cur_pos = 0
		progress.value = 0

func _on_progress_value_changed(value):
	cur_pos = value
	set_time(int(cur_pos))
	set_timeline(cur_pos)

var pressed = false
func _unhandled_key_input(event):
	if event.pressed:
		if not pressed:
			pressed = true
			match event.scancode:
				KEY_1:
					add_tag(0)
				KEY_2:
					add_tag(1)
				KEY_3:
					add_tag(2)
				KEY_4:
					add_tag(3)
				KEY_5:
					add_tag(4)
				KEY_6:
					add_tag(5)
				KEY_7:
					add_tag(6)
				KEY_8:
					add_tag(7)
				KEY_Z:
					add_eye('normal')
				KEY_X:
					add_eye('heart')
				KEY_C:
					add_eye('hurt')
				KEY_V:
					add_eye('sad')
				KEY_B:
					add_eye('what')
				
	else:
		pressed =false

func add_tag(n):
	body.frame = n
	var at = timeline.rect_size.x
	var inst = _tag_scene.instance()
	inst.num = n
	inst.at = int(at)
	Tags.tags[int(at)] = {
		'body':n,
		'eye':'normal'
	}
	eyes.play('normal')
	inst.rect_position = Vector2(at-14,-16)
	tags_parent.add_child(inst)

func add_eye(eye):
	var at = int(timeline.rect_size.x)
	if Tags.tags.has(at):
		Tags.tags[at]['eye'] = eye
		eyes.play(eye)
