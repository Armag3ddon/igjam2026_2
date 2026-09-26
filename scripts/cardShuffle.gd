extends Node2D


var cards: Array[Node];
var areCardsShuffled: bool = false:
	set(value):
		areCardsShuffled = value
	get():
		return areCardsShuffled
		
@export var timesToMove: int = 2;
@export var cardSwitchSpeed: float = 1.5;
@export var cardJumpHeight: float = 650;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards = $Cardhandler.get_children()
	_cardsInit()
	_MoveCards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass
	
func _cardsInit()-> void:
	cards.shuffle();
	
	
func _MoveCards()-> void:
	for i in range(0,timesToMove):
		var firstCardIndex = randi_range(0,cards.size()-1);
		var secondCardIndex = randi_range(0,cards.size()-1);
		while firstCardIndex == secondCardIndex:
			secondCardIndex = randi_range(0,cards.size()-1);
		var firstSelectedCard = cards[firstCardIndex];
		var secondSelectedCard = cards[secondCardIndex];
		var firstCardOriginalTransform = firstSelectedCard.position
		var secondCardOriginalTransform = secondSelectedCard.position
		switchCards(firstSelectedCard,firstCardOriginalTransform,secondCardOriginalTransform,cardJumpHeight,cardSwitchSpeed)
		await switchCards(secondSelectedCard,secondCardOriginalTransform,firstCardOriginalTransform,-cardJumpHeight,cardSwitchSpeed)
		#await switchCards(secondSelectedCard,firstCardOriginalTransform,secondCardOriginalTransform,-650,cardSwitchSpeed)
		
	print("Shuffle done")
	areCardsShuffled = true
func switchCards(cardToMove: Node2D,start: Vector2, target: Vector2, height: float, duration: float)-> void:
	var tween = create_tween()
	tween.tween_method(
		func(t: float):
			var pos = start.lerp(target, t)
			pos.y -= sin(t * PI) * height
			cardToMove.position = pos, 0.0, 1.0, duration
	)
	await tween.finished
	
