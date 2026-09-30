extends Control

class_name BirdComment

@onready var bird_name = $PanelContainer/Birdname
@onready var bird_text = $Panel/RichTextLabel
@onready var bird_portrait = $Character
@onready var bird_sound = $Birdcall

func setup(name: String, text: String, portrait: String, audio: String) -> void:
	var texture: Texture2D = load(portrait)
	var stream: AudioStream = load(audio)
	bird_name.text = name
	bird_text.text = text
	bird_portrait.texture = texture
	bird_sound.stream = stream
	bird_sound.play()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_parent().drawDanger()
		get_parent().remove_child(self)
		queue_free()
