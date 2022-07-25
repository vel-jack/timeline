extends Control

# onready
onready var body = $Control/body
onready var eyes = $Control/eyes
onready var audio = $AudioStreamPlayer
onready var anim = $AnimationPlayer

func _ready():
	audio.stream = load(Common.audio_path)
	$timer.start()

# warning-ignore:unused_argument
func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_select"):
		if audio.playing:
			audio.stop()
			body.frame = 0
			eyes.play('normal')
		else:
			audio.play()



# warning-ignore:unused_argument
func _process(delta):
	if audio.playing:
		var a = audio.get_playback_position()
		set_frame(str(int(a)))

var last_sec
func set_frame(x):
	if x in Common.tags.keys():
		if last_sec != x:
			last_sec = x
			anim.play("wiggle")
			return
		body.frame = Common.tags[x]['body']
		if not blinking:
			eyes.play(Common.tags[x]['eye'])

var blinking = false
func _on_timer_timeout():
	if eyes.animation == 'normal':
		eyes.play('blink')
		blinking = true
	yield(eyes,"animation_finished")
	eyes.play('normal')
	blinking = false
