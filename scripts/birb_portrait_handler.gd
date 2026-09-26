extends Node2D


var crows: Array[Node];
var parot: Array[Node];
var owl: Array[Node];
var pigeon: Array[Node];
var goose: Array[Node];
var cardsPicked: Array[bool] = [false,false,false,false,false];
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
@onready var cards_node = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	crows = $CrowHandler.get_children()
	parot = $ParotHandler.get_children()
	owl = $OwlHandler.get_children()
	pigeon = $PigeonHandler.get_children()
	goose = $GooseHandler.get_children()
	if playerCount > 0:
		#AssignAnimalToPlayers(Global.player_one_bird) REINMACHEN WENN VERKNÜOFT
		AssignAnimalToPlayer1(0)
		if playerCount ==2:
			AssignAnimalToPlayer2(3)
			#AssignAnimalToPlayers(Global.player_two_bird)   REINMACHEN WENN VERKNÜOFT
	#crows[payerOneIsOverCard-1].visible = true;
	#parot[payerTwoIsOverCard-1].visible = true;

func AssignAnimalToPlayer1(chosen_bird: Global.BIRDS) -> void:
	playerOneAnimalPortrait = chosen_bird
	if chosen_bird == 0: #crow
		playerOneAnimal = crows
	elif chosen_bird == 1: #Goose
		playerOneAnimal = goose
	elif chosen_bird == 2: #OWL
		playerOneAnimal = owl
	elif chosen_bird == 3: #PARROT
		playerOneAnimal = parot
	elif chosen_bird == 4: #PIGEON
		playerOneAnimal = pigeon
	pass

func AssignAnimalToPlayer2(chosen_bird: Global.BIRDS) -> void:
	playerTwoAnimalPortrait = chosen_bird
	if chosen_bird == 0: #crow
		playerTwoAnimal = crows
	elif chosen_bird == 1: #Goose
		playerTwoAnimal = goose
	elif chosen_bird == 2: #OWL
		playerTwoAnimal = owl
	elif chosen_bird == 3: #PARROT
		playerTwoAnimal = parot
	elif chosen_bird == 4: #PIGEON
		playerTwoAnimal = pigeon
	pass


func _process(delta: float) -> void:
	PickControlls()
	
func PickControlls():
	if playerCount == 1:
		if Input.is_action_just_released("PlayerOne_Left") && !isPlayerInput1Blocked:
			if payerOneIsOverCard > 1:
				playerOneAnimal[payerOneIsOverCard-1].visible = false;
				payerOneIsOverCard -= 1
				playerOneAnimal[payerOneIsOverCard-1].visible = true;
			
		if Input.is_action_just_released("PlayerOne_Right") && !isPlayerInput1Blocked:
			if payerOneIsOverCard < 5:
				playerOneAnimal[payerOneIsOverCard-1].visible = false;
				payerOneIsOverCard += 1
				playerOneAnimal[payerOneIsOverCard-1].visible = true;
				print ("Nach Rechts")
				print(isPlayerInput1Blocked)
		if cards_node.areCardsShuffled == true && Input.is_action_just_released("PlayerOne_Accept") && !isPlayerInput1Blocked:
			
			if CheckIfCardIsAvailable(payerOneIsOverCard-1):
				P1AssignChoiceToCard(payerOneIsOverCard-1,playerOneAnimalPortrait)
				isPlayerInput1Blocked = true;
			print("Eingeloggt")
			
			
	if playerCount == 2:
		if Input.is_action_just_released("PlayerOne_Left") && !isPlayerInput1Blocked:
			if payerOneIsOverCard > 1:
				playerOneAnimal[payerOneIsOverCard-1].visible = false;
				payerOneIsOverCard -= 1
				playerOneAnimal[payerOneIsOverCard-1].visible = true;
			
		if Input.is_action_just_released("PlayerOne_Right") && !isPlayerInput1Blocked:
			if payerOneIsOverCard < 5:
				playerOneAnimal[payerOneIsOverCard-1].visible = false;
				payerOneIsOverCard += 1
				playerOneAnimal	[payerOneIsOverCard-1].visible = true;
				print ("P1 Nach Rechts")
		if cards_node.areCardsShuffled == true && Input.is_action_just_released("PlayerOne_Accept") && !isPlayerInput1Blocked:
			if CheckIfCardIsAvailable(payerOneIsOverCard-1):
				P1AssignChoiceToCard(payerOneIsOverCard-1,playerOneAnimalPortrait)
				isPlayerInput1Blocked = true;
			print("P1Eingeloggt")
			
			
		if Input.is_action_just_released("PlayerTwo_Left") && !isPlayerInput2Blocked:
			if payerTwoIsOverCard > 1:
				
				playerTwoAnimal[payerTwoIsOverCard-1].visible = false;
				payerTwoIsOverCard -= 1
				playerTwoAnimal[payerTwoIsOverCard-1].visible = true;
			
		if Input.is_action_just_released("PlayerTwo_Right") && !isPlayerInput2Blocked:
			if payerTwoIsOverCard < 5:
				playerTwoAnimal[payerTwoIsOverCard-1].visible = false;
				payerTwoIsOverCard += 1
				playerTwoAnimal[payerTwoIsOverCard-1].visible = true;
				print (isPlayerInput2Blocked)
				print(cards_node.areCardsShuffled)
		if cards_node.areCardsShuffled == true && Input.is_action_just_released("PlayerTwo_Accept") && !isPlayerInput2Blocked:
			if CheckIfCardIsAvailable(payerTwoIsOverCard-1):
				P2AssignChoiceToCard(payerTwoIsOverCard-1,playerTwoAnimalPortrait)
				isPlayerInput2Blocked = true;
			print("P2Eingeloggt")

func P1AssignChoiceToCard(cardIndex: int, playerAnimal: int):
	if !cardsPicked[cardIndex]:
		cardsPicked[cardIndex] = true #Belegen der Karte
		playerOneAnimal[payerOneIsOverCard-1].visible = false; 
		if payerOneIsOverCard == 1:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		if payerOneIsOverCard == 2:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		
		if payerOneIsOverCard == 3:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		if payerOneIsOverCard == 4:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
				
		if payerOneIsOverCard == 5:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#Portrait anzeigen
	pass
	
func P2AssignChoiceToCard(cardIndex: int, playerAnimal: int):
	if !cardsPicked[cardIndex]:
		cardsPicked[cardIndex] = true #Belegen der Karte
		playerTwoAnimal[payerTwoIsOverCard-1].visible = false; 
		if payerTwoIsOverCard == 1:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card1/Portrait".visible = true
				$"../Cardhandler/Card1/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		if payerTwoIsOverCard == 2:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card2/Portrait".visible = true
				$"../Cardhandler/Card2/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		
		if payerTwoIsOverCard == 3:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card3/Portrait".visible = true
				$"../Cardhandler/Card3/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		if payerTwoIsOverCard == 4:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card4/Portrait".visible = true
				$"../Cardhandler/Card4/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
				
		if payerTwoIsOverCard == 5:
			if playerAnimal == 0: #Crow
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/crow_portrait.jpg")
			if playerAnimal == 1: #Goose
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/goose_portrait.jpg")
			if playerAnimal == 2: #OWL
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/owl_portrait.jpg")
			if playerAnimal == 3: #Parrot
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/parrot_portrait.jpg")
			if playerAnimal == 4: #Pigeon
				$"../Cardhandler/Card5/Portrait".visible = true
				$"../Cardhandler/Card5/Portrait".texture  = load("res://assets/portraits/pigeon_portrait.jpg")
		#Portrait anzeigen
	pass
func CheckIfCardIsAvailable(cardIndex: int) -> bool:
	if cardsPicked[cardIndex]:
		return false
	return true
	
