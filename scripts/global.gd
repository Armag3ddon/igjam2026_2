extends Node

var player_count: int = 1

var player_one_bird: int
var player_two_bird: int

var is_player_human: Array[bool] = [false, false, false, false, false]

var winner_winner_chicken_dinner = [false, true, false, true, false]

var with_tutorial: bool = true

var tutorials: Array[bool] = [false, false, false, false, false]

enum TUTORIAL {
	GAMESTART,
	BIRDPOSITION,
	DANGERS,
	DRAWBEGIN,
	DRAWEND
}

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

func showTutorial(number: int, parent: Node) -> void:
	if tutorials[number]:
		return
	var position: Vector2 = getTutorialPosition(number)
	position -= Vector2(400.0, 350.0)
	var text: String = getTutorialText(number)
	Tutorial.showTutorial(position, text, parent)
	tutorials[number] = true
	get_tree().paused = true

func getTutorialText(number: int) -> String:
	match number:
		TUTORIAL.GAMESTART:
			return "Welcome to the race! Try to reach the top of the screen to be the [b]early bird[/b]."
		TUTORIAL.BIRDPOSITION:
			return "Take note of the position of your bird. It is on one of 5 vertical lanes."
		TUTORIAL.DANGERS:
			return "See these warnings? Obstacles will soon drop down those lanes."
		TUTORIAL.DRAWBEGIN:
			return "To move lanes, you must select one of these cards: two to left, to the left, stay, to the right, two to the right.\nMove your bird's portrait at the bottom to the card you think fits best. Every bird selects one card but only one bird can select a card."
		TUTORIAL.DRAWEND:
			return "Did you follow your favorite card? Select it now with your Accept key but be quick. The other birds will also "
	return ""

func getTutorialPosition(number: int) -> Vector2:
	match number:
		TUTORIAL.GAMESTART:
			return Vector2(960.0, 540.0)
		TUTORIAL.BIRDPOSITION:
			return Vector2(960.0, 50.0)
		TUTORIAL.DANGERS:
			return Vector2(960.0, 700.0)
		TUTORIAL.DRAWBEGIN:
			return Vector2(500.0, 500.0)
		TUTORIAL.DRAWEND:
			return Vector2(1000.0, 500.0)
	return Vector2(960.0, 540.0)

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
			"You look great from 30,000 feet up.",
			"Check the rearview mirror. That’s the closest you’ll get to me all day.",
			"I’d love to stay and chat, but I have a finish line to catch.",
			"If you aren’t first, you’re just part of the scenery.",
			"Eat my dust. It’s the only thing on the menu today.",
			"Are you guys flying or just taking a scenic tour?",
			"My favorite view is a completely empty track ahead of me.",
			"I think you dropped something back there. Oh wait, it was just your pace.",
			"You gave it your all, but my all was just a little too fast.",
			"Don't worry, the view of my tail feathers gets better the further ahead I get.",
			"I’d tell you to catch up, but I don't like making impossible promises."
		]
	return gloats.pick_random()
