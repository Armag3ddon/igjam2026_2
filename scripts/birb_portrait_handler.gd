extends Control

var current_player_selections: Array[int] = [2, 2, 2, 2, 2]

@onready var crows: Array[Node] = $CrowHandler.get_children()
@onready var parrots: Array[Node] = $ParrotHandler.get_children()
@onready var owls: Array[Node] = $OwlHandler.get_children()
@onready var pigeons: Array[Node] = $PigeonHandler.get_children()
@onready var geese: Array[Node] = $GooseHandler.get_children()

var cardsPicked: Array[bool] = [false,false,false,false,false]
var player_has_picked: Array[bool] = [false,false,false,false,false]
var cards_picked_count: int = 0
var selection_finished: bool = false
var selection_started: bool = false

@onready var cards_node = get_parent()

var playerOneAnimal: Array[Node];
var playerOneAnimalPortrait: int;
var playerTwoAnimalPortrait: int;
var isPlayerInput1Blocked: bool = false;
var playerTwoAnimal: Array[Node];
var isPlayerInput2Blocked: bool = false;
var areCardsShuffled: bool = false
var playerOneLoggedIn: bool = false
var playerTwoLoggedIn: bool = false
var playerCount: int = 2;
var payerOneIsOverCard: int = 3;
var payerTwoIsOverCard: int = 3;


func switchPlayerToCard(player: int, card: int) -> void:
	match player:
		Global.BIRDS.CROW:
			crows[current_player_selections[player]].visible = false
			crows[card].visible = true
		Global.BIRDS.GOOSE:
			geese[current_player_selections[player]].visible = false
			geese[card].visible = true
		Global.BIRDS.OWL:
			owls[current_player_selections[player]].visible = false
			owls[card].visible = true
		Global.BIRDS.PARROT:
			parrots[current_player_selections[player]].visible = false
			parrots[card].visible = true
		Global.BIRDS.PIGEON:
			pigeons[current_player_selections[player]].visible = false
			pigeons[card].visible = true
	current_player_selections[player] = card

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PlayerOne_Left"):
		switchPlayerToCard(Global.player_one_bird, wrapAround(current_player_selections[Global.player_one_bird] - 1))
	if event.is_action_pressed("PlayerOne_Right"):
		switchPlayerToCard(Global.player_one_bird, wrapAround(current_player_selections[Global.player_one_bird] + 1))
	if event.is_action_pressed("PlayerTwo_Left") and Global.player_count > 1:
		switchPlayerToCard(Global.player_two_bird, wrapAround(current_player_selections[Global.player_two_bird] - 1))
	if event.is_action_pressed("PlayerTwo_Right") and Global.player_count > 1:
		switchPlayerToCard(Global.player_two_bird, wrapAround(current_player_selections[Global.player_two_bird] + 1))
	if event.is_action_pressed("PlayerOne_Accept") and selection_started:
		if not cardsPicked[current_player_selections[Global.player_one_bird]]:
			playerSelectsCard(Global.player_one_bird, current_player_selections[Global.player_one_bird], cards_node.cards[current_player_selections[Global.player_one_bird]])
	if event.is_action_pressed("PlayerTwo_Accept") and Global.player_count > 1 and selection_started:
		if not cardsPicked[current_player_selections[Global.player_two_bird]]:
			playerSelectsCard(Global.player_two_bird, current_player_selections[Global.player_two_bird], cards_node.cards[current_player_selections[Global.player_two_bird]])

func wrapAround(card: int) -> int:
	if card < 0:
		return card + 5
	if card > 4:
		return card - 5
	return card

func _process(delta: float) -> void:
	if not selection_started:
		for i: int in 5:
			if not Global.is_player_human[i]:
				if randf() < 0.005:
					switchPlayerToCard(i, wrapAround(current_player_selections[i] + (randi() % 3 -1)))
	if cards_picked_count == 4:
		autoSelectLastCard()
	if cards_picked_count == 5 and not selection_finished:
		cards_node.selectionDone()
		selection_finished = true

func autoSelectLastCard() -> void:
	for i: int in 5:
		if not player_has_picked[i]:
			for j: int in 5:
				if not cardsPicked[j]:
					playerSelectsCard(i, j, cards_node.cards[j])

func selectCardForBot(bird: int, strategy: Array, card_order: Array[Node]) -> void:
	if player_has_picked[bird]:
		return
	var accuracy: float = Global.bird_bots[bird][Global.BIRDBOT.ACCURACY]
	var accurate_roll: float = randf() * 100.0
	if accurate_roll < accuracy:
		if not selectCorrectCard(bird, strategy, card_order):
			selectIncorrectCard(bird, strategy, card_order)
	else:
		if not selectIncorrectCard(bird, strategy, card_order):
			selectCorrectCard(bird, strategy, card_order)

func selectCorrectCard(bird: int, strategy: Array, card_order: Array[Node]) -> bool:
	var found: bool = false
	var i: int = 0
	for card: Node in card_order:
		if found:
			continue
		if strategy.has(card.card_type):
			if not cardsPicked[i]:
				playerSelectsCard(bird, i, card_order[i])
				found = true
		i += 1
	return found

func selectIncorrectCard(bird: int, strategy: Array, card_order: Array[Node]) -> bool:
	var found: bool = false
	var i: int = 0
	for card: Node in card_order:
		if found:
			continue
		if not strategy.has(card.card_type):
			if not cardsPicked[i]:
				playerSelectsCard(bird, i, card_order[i])
				found = true
		i += 1
	return found

func playerSelectsCard(player: int, card: int, card_node: Node) -> void:
	if cardsPicked[card]:
		return
	var player_texture: Texture2D = load(Global.getBirdPortrait(player))
	match player:
		Global.BIRDS.CROW:
			crows[current_player_selections[player]].visible = false
		Global.BIRDS.GOOSE:
			geese[current_player_selections[player]].visible = false
		Global.BIRDS.OWL:
			owls[current_player_selections[player]].visible = false
		Global.BIRDS.PARROT:
			parrots[current_player_selections[player]].visible = false
		Global.BIRDS.PIGEON:
			pigeons[current_player_selections[player]].visible = false
	card_node.selection_portrait.texture = player_texture
	card_node.selection_portrait.visible = true
	card_node.picked()
	cardsPicked[card] = true
	current_player_selections[player] = card
	player_has_picked[player] = true
	cards_picked_count += 1

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#
##	crows = $CrowHandler.get_children()
##	parot = $ParrotHandler.get_children()
##	owl = $OwlHandler.get_children()
##	pigeon = $PigeonHandler.get_children()
##	goose = $GooseHandler.get_children()
	#if playerCount > 0:
		##AssignAnimalToPlayers(Global.player_one_bird) REINMACHEN WENN VERKNÜOFT
		#AssignAnimalToPlayer1(0)
		#if playerCount ==2:
			#AssignAnimalToPlayer2(3)
			##AssignAnimalToPlayers(Global.player_two_bird)   REINMACHEN WENN VERKNÜOFT
	##crows[payerOneIsOverCard-1].visible = true;
	##parot[payerTwoIsOverCard-1].visible = true;
#
#func AssignAnimalToPlayer1(chosen_bird: Global.BIRDS) -> void:
	#playerOneAnimalPortrait = chosen_bird
	#if chosen_bird == 0: #crow
		#playerOneAnimal = crows
	#elif chosen_bird == 1: #Goose
		#playerOneAnimal = goose
	#elif chosen_bird == 2: #OWL
		#playerOneAnimal = owl
	#elif chosen_bird == 3: #PARROT
		#playerOneAnimal = parot
	#elif chosen_bird == 4: #PIGEON
		#playerOneAnimal = pigeon
	#pass
#
#func AssignAnimalToPlayer2(chosen_bird: Global.BIRDS) -> void:
	#playerTwoAnimalPortrait = chosen_bird
	#if chosen_bird == 0: #crow
		#playerTwoAnimal = crows
	#elif chosen_bird == 1: #Goose
		#playerTwoAnimal = goose
	#elif chosen_bird == 2: #OWL
		#playerTwoAnimal = owl
	#elif chosen_bird == 3: #PARROT
		#playerTwoAnimal = parot
	#elif chosen_bird == 4: #PIGEON
		#playerTwoAnimal = pigeon
	#pass
#
#
#func _process(delta: float) -> void:
	#PickControlls()
#
#func PickControlls():
	#if playerCount == 1:
		#if Input.is_action_just_released("PlayerOne_Left") && !isPlayerInput1Blocked:
			#if payerOneIsOverCard > 1:
				#playerOneAnimal[payerOneIsOverCard-1].visible = false;
				#payerOneIsOverCard -= 1
				#playerOneAnimal[payerOneIsOverCard-1].visible = true;
			#
		#if Input.is_action_just_released("PlayerOne_Right") && !isPlayerInput1Blocked:
			#if payerOneIsOverCard < 5:
				#playerOneAnimal[payerOneIsOverCard-1].visible = false;
				#payerOneIsOverCard += 1
				#playerOneAnimal[payerOneIsOverCard-1].visible = true;
				#print ("Nach Rechts")
				#print(isPlayerInput1Blocked)
		#if cards_node.areCardsShuffled == true && Input.is_action_just_released("PlayerOne_Accept") && !isPlayerInput1Blocked:
			#
			#if CheckIfCardIsAvailable(payerOneIsOverCard-1):
				#P1AssignChoiceToCard(payerOneIsOverCard-1,playerOneAnimalPortrait)
				#isPlayerInput1Blocked = true;
			#print("Eingeloggt")
			#
			#
	#if playerCount == 2:
		#if Input.is_action_just_released("PlayerOne_Left") && !isPlayerInput1Blocked:
			#if payerOneIsOverCard > 1:
				#playerOneAnimal[payerOneIsOverCard-1].visible = false;
				#payerOneIsOverCard -= 1
				#playerOneAnimal[payerOneIsOverCard-1].visible = true;
			#
		#if Input.is_action_just_released("PlayerOne_Right") && !isPlayerInput1Blocked:
			#if payerOneIsOverCard < 5:
				#playerOneAnimal[payerOneIsOverCard-1].visible = false;
				#payerOneIsOverCard += 1
				#playerOneAnimal	[payerOneIsOverCard-1].visible = true;
				#print ("P1 Nach Rechts")
		#if Input.is_action_just_released("PlayerOne_Accept") && !isPlayerInput1Blocked:
			#if CheckIfCardIsAvailable(payerOneIsOverCard-1):
				#P1AssignChoiceToCard(payerOneIsOverCard-1,playerOneAnimalPortrait)
				#isPlayerInput1Blocked = true;
			#print("P1Eingeloggt")
			#
			#
		#if Input.is_action_just_released("PlayerTwo_Left") && !isPlayerInput2Blocked:
			#if payerTwoIsOverCard > 1:
				#
				#playerTwoAnimal[payerTwoIsOverCard-1].visible = false;
				#payerTwoIsOverCard -= 1
				#playerTwoAnimal[payerTwoIsOverCard-1].visible = true;
			#
		#if Input.is_action_just_released("PlayerTwo_Right") && !isPlayerInput2Blocked:
			#if payerTwoIsOverCard < 5:
				#playerTwoAnimal[payerTwoIsOverCard-1].visible = false;
				#payerTwoIsOverCard += 1
				#playerTwoAnimal[payerTwoIsOverCard-1].visible = true;
				#print (isPlayerInput2Blocked)
				#print(cards_node.areCardsShuffled)
		#if Input.is_action_just_released("PlayerTwo_Accept") && !isPlayerInput2Blocked:
			#if CheckIfCardIsAvailable(payerTwoIsOverCard-1):
				#P2AssignChoiceToCard(payerTwoIsOverCard-1,playerTwoAnimalPortrait)
				#isPlayerInput2Blocked = true;
			#print("P2Eingeloggt")
#
#func P1AssignChoiceToCard(cardIndex: int, playerAnimal: int):
	#if !cardsPicked[cardIndex]:
		#cardsPicked[cardIndex] = true #Belegen der Karte
		#playerOneAnimal[payerOneIsOverCard-1].visible = false; 
		#if payerOneIsOverCard == 1:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#if payerOneIsOverCard == 2:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#
		#if payerOneIsOverCard == 3:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#if payerOneIsOverCard == 4:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
				#
		#if payerOneIsOverCard == 5:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		##Portrait anzeigen
	#pass
	#
#func P2AssignChoiceToCard(cardIndex: int, playerAnimal: int):
	#if !cardsPicked[cardIndex]:
		#cardsPicked[cardIndex] = true #Belegen der Karte
		#playerTwoAnimal[payerTwoIsOverCard-1].visible = false; 
		#if payerTwoIsOverCard == 1:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card1/Portrait".visible = true
				#$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#if payerTwoIsOverCard == 2:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card2/Portrait".visible = true
				#$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#
		#if payerTwoIsOverCard == 3:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card3/Portrait".visible = true
				#$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#if payerTwoIsOverCard == 4:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card4/Portrait".visible = true
				#$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
				#
		#if payerTwoIsOverCard == 5:
			#if playerAnimal == 0: #Crow
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			#if playerAnimal == 1: #Goose
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			#if playerAnimal == 2: #OWL
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			#if playerAnimal == 3: #Parrot
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			#if playerAnimal == 4: #Pigeon
				#$"../Cardhandler/Card5/Portrait".visible = true
				#$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		##Portrait anzeigen
	#pass
#func CheckIfCardIsAvailable(cardIndex: int) -> bool:
	#if cardsPicked[cardIndex]:
		#return false
	#return true
	#
