extends Control

@export var timesToMove: int = 2;
@export var cardSwitchSpeed: float = 1.5;
@export var cardJumpHeight: float = 650;

@onready var cards: Array[Node] = [$Cardhandler/Card1, $Cardhandler/Card2, $Cardhandler/Card3, $Cardhandler/Card4, $Cardhandler/Card5]

enum draw_states {
	NOTHING,
	WAIT,
	FLIP,
	SHUFFLE,
	SELECT,
	END
}

var draw_state: int = 0

var wait_time: float = 0.0
var wait_wait: float = 2.0

var card_to_flip: int = 0

var flip_time: float = 0.0

func setupCards(card_types: Array[int]) -> void:
	card_types.shuffle()
	var i: int = 0
	for card: int in card_types:
		cards[i].setCardType(card, get_parent().getCardAsset(card))
		i += 1

func init() -> void:
	draw_state = draw_states.WAIT

func flipCard(to_flip: int) -> void:
	if to_flip >= cards.size():
		draw_state = draw_states.SHUFFLE
		shuffleCards()
		return
	cards[to_flip].flip(self)

func flipNextCard() -> void:
	card_to_flip += 1
	flipCard(card_to_flip)

func shuffleCards() -> void:
	timesToMove -= 1
	if timesToMove < 0:
		draw_state = draw_states.SELECT
		return
	var first_card_index: int = randi_range(0,cards.size()-1)
	var second_card_index: int = randi_range(0,cards.size()-1)
	while first_card_index == second_card_index:
		second_card_index = randi_range(0,cards.size()-1)
	var first_card: Control = cards[first_card_index]
	var second_card: Control = cards[second_card_index]
	switchCards(first_card, first_card.position, second_card.position, cardJumpHeight, cardSwitchSpeed)
	switchCards(second_card, second_card.position, first_card.position, -cardJumpHeight, cardSwitchSpeed)
	cards[first_card_index] = second_card
	cards[second_card_index] = first_card
	flip_time = 0.0

func _process(delta: float) -> void:
	if draw_state == draw_states.WAIT:
		wait_time += delta
		if wait_time >= wait_wait:
			draw_state = draw_states.FLIP
			flipCard(card_to_flip)
			$GetReady.visible = false
	if draw_state == draw_states.SHUFFLE:
		flip_time += delta
		if flip_time > cardSwitchSpeed:
			shuffleCards()

func switchCards(cardToMove: Control,start: Vector2, target: Vector2, height: float, duration: float)-> void:
	var tween = create_tween()
	tween.tween_method(
		func(t: float):
			var pos = start.lerp(target, t)
			pos.y -= sin(t * PI) * height
			cardToMove.position = pos, 0.0, 1.0, duration
	)
