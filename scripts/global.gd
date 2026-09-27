extends Node

var player_count: int = 1

var player_one_bird: int
var player_two_bird: int

var is_player_human: Array[bool] = [false, false, false, false, false]

var winner_winner_chicken_dinner = [false, true, false, true, false]

var bird_bots: Array[Array] = [
	[2.0, 50.0], # Crow: balanced
	[1.5, 25.0], # Goose: quicker but worse
	[3.0, 100.1], # Owl: slow but perfect
	[2.5, 75.0], # Parrot: slower but better
	[0.5, 0.0] # Pigeon: quick but random
]

enum BIRDS {
	CROW,
	GOOSE,
	OWL,
	PARROT,
	PIGEON
}

enum BIRDBOT {
	SPEED,
	ACCURACY
}

func getBirdPackedScene(bird: int) -> PackedScene:
	if bird == BIRDS.CROW:
		return preload("res://scenes/birds/crow.tscn")
	if bird == BIRDS.GOOSE:
		return preload("res://scenes/birds/goose.tscn")
	if bird == BIRDS.OWL:
		return preload("res://scenes/birds/owl.tscn")
	if bird == BIRDS.PARROT:
		return preload("res://scenes/birds/parrot.tscn")
	if bird == BIRDS.PIGEON:
		return preload("res://scenes/birds/pigeon.tscn")
	return

func getBirdPortrait(bird: int) -> String:
	if bird == BIRDS.CROW:
		return "res://assets/portraits/portrait_crow.png"
	if bird == BIRDS.GOOSE:
		return "res://assets/portraits/portrait_goose.png"
	if bird == BIRDS.OWL:
		return "res://assets/portraits/portrait_owl.png"
	if bird == BIRDS.PARROT:
		return "res://assets/portraits/portrait_parrot.png"
	if bird == BIRDS.PIGEON:
		return "res://assets/portraits/portrait_pigeon.png"
	return ""

func getBirdGloatPortrait(bird: int) -> String:
	if bird == BIRDS.CROW:
		return "res://assets/portraits/portrait_crow_gloat.png"
	if bird == BIRDS.GOOSE:
		return "res://assets/portraits/portrait_goose_gloat.png"
	if bird == BIRDS.OWL:
		return "res://assets/portraits/portrait_owl_gloat.png"
	if bird == BIRDS.PARROT:
		return "res://assets/portraits/portrait_parrot_gloat.png"
	if bird == BIRDS.PIGEON:
		return "res://assets/portraits/portrait_pigeon_gloat.png"
	return ""

func getBirdCall(bird: int) -> String:
	if bird == BIRDS.CROW:
		return "res://assets/snd/Crow.mp3"
	if bird == BIRDS.GOOSE:
		return "res://assets/snd/Goose.mp3"
	if bird == BIRDS.OWL:
		return "res://assets/snd/Owl.mp3"
	if bird == BIRDS.PARROT:
		return "res://assets/snd/Parrot.mp3"
	if bird == BIRDS.PIGEON:
		return "res://assets/snd/Pigeon.mp3"
	return ""

func getBirdNames(bird: int) -> String:
	if bird == BIRDS.CROW:
		return "CRUEL Crow"
	if bird == BIRDS.GOOSE:
		return "GUTTING Goose"
	if bird == BIRDS.OWL:
		return "ONSLAUGHT Owl"
	if bird == BIRDS.PARROT:
		return "PAIN Parrot"
	if bird == BIRDS.PIGEON:
		return "PIGEON"
	return ""

func getBirdGloat(bird: int) -> String:
	if bird == BIRDS.PIGEON:
		return "Coo!"
	var gloats: Array[String] = [
			"Don't blink, or you'll mistake me for a shooting star.",
			"You’re flying in my slipstream. Try not to choke on it.",
			"I left you so far behind you're entering a different time zone.",
			"The sky isn't the limit. It's my starting line.",
			"Requesting permission to fly solo at the front. It’s getting crowded in the back.",
			"You look great from 30,000 feet up."
		]
	return gloats.pick_random()
