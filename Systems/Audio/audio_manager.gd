extends Node2D

@onready var bg_stream_player = $AudioStreamPlayer

@onready var scene_manager = $"../SceneManager"
@onready var minigame_manager = $"../MinigameManager"

# Minigame music.
var watering_flowers_bg: AudioStream = load("res://Minigame Files/Minigame Files - Audio/Watering Can (with a beat!).wav")
var fishing_bg: AudioStream = load("res://Minigame Files/Minigame Files - Audio/fihost.mp3")
var caterpillars_bg: AudioStream 
var nest_bg: AudioStream = load("res://Minigame Files/Minigame Files - Audio/N.E.S.T..wav")
var spider_bg: AudioStream = load("res://Minigame Files/Minigame Files - Audio/spiderclawmachine.mp3")

# Other music.
var title_bg: AudioStream = load("res://Menus/Menus - Audio/titlescreen.mp3")
var gameover_bg: AudioStream = load("res://Systems/Scene Management/Audio/titlescreenalt.mp3")
var garden_bg: AudioStream = load("res://Garden/Garden - Audio/Panorama.wav")

var bg_playlist = AudioStreamPlaylist.new()

@export var full_volume: float = 10

var current_audio_stream

func populate_playlist() -> void:
	bg_playlist.set_list_stream(0, title_bg)
	bg_playlist.set_list_stream(1, garden_bg)
	bg_playlist.set_list_stream(2, fishing_bg)
	bg_playlist.set_list_stream(3, watering_flowers_bg)
	bg_playlist.set_list_stream(4, caterpillars_bg)
	bg_playlist.set_list_stream(5, nest_bg)
	bg_playlist.set_list_stream(7, spider_bg)
	bg_playlist.set_list_stream(8, gameover_bg)

func set_audio_playing(audio_index: int) -> void:
	if (bg_playlist.get_list_stream(audio_index) != current_audio_stream):
		current_audio_stream = bg_playlist.get_list_stream(audio_index)
		bg_stream_player.stream = current_audio_stream
		bg_stream_player.play()

func _ready() -> void:
	scene_manager.audio_change_request.connect(set_audio_playing)
	minigame_manager.audio_change_request.connect(set_audio_playing)
	
	populate_playlist()
	
	set_audio_playing(0)

	bg_stream_player.play()


#func fade_in(stream_player: AudioStreamPlayer, chosen_audio: AudioStream) -> void:
	#stream_player.stream = chosen_audio
	#stream_player.volume_db = 0
	#
	#current_active_audio = chosen_audio
	#
	#var tween_in = create_tween()
	#tween_in.tween_property(stream_player, "volume_db", full_volume, 2.0)
	#tween_in.play()
#
#
#func fade_out(stream_player: AudioStreamPlayer) -> void:
	#var tween_out = create_tween()
	#tween_out.tween_property(stream_player, "volume_db", 0, 2.0)
	#
	#stream_player.stream = null
	#current_active_audio = null
