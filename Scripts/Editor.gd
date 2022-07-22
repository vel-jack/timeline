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
onready var cursor = $Vbox/ControllerUI/VBoxContainer/slider/cursor
onready var audio_player = $AudioPlayer
onready var timeline = $Vbox/ControllerUI/VBoxContainer/Editor/Control/Timeline
onready var timeline_bg =$Vbox/ControllerUI/VBoxContainer/Editor/Control/TimelineBg


func _ready():
	audio_player.stream = load("res://Assets/cool.mp3")
	audio_length = audio_player.stream.get_length()
	progress.max_value = audio_length
	audio_length_str = to_time(int(audio_length))
	set_curser(0)


func set_curser(t):
	cursor.text = to_time(t)+'/'+audio_length_str;

func to_time(secs):
	return "%02d:%02d" % [(secs/60)%60,secs%60]

# warning-ignore:unused_argument
func _process(delta):
	if audio_player.playing:
		var a = audio_player.get_playback_position()
		set_curser(int(a))
		progress.value = a
		timeline.rect_size = Vector2(timeline_bg.rect_size.x* (a/audio_length*100)/100 ,10)
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
