"
Soy una herramienta de los tests, no formo parte del modelo del juego.

Armo un Game válido con valores por defecto (1 nave, tablero de 10 celdas sin efectos,
wormhole entre 2 y 4, 20 parsecs, 1 vuelta, dado cargado que siempre saca 1 y mazo al azar),
para que cada test configure solo lo que le resulta relevante (patrón Builder).

Ejemplo:
	aGame := GameBuilder new
		shipsNamed: #( 'ship 1' 'ship 2' );
		diceSequence: #( 6 3 );
		allCellsWith: BlackHole;
		build.

El Game resultante se crea siempre con su única forma de inicialización
(Game class >> with:using:andShipsNamed:until:cardManager:).
"
Class {
	#name : 'GameBuilder',
	#superclass : 'Object',
	#instVars : [
		'shipNames',
		'dice',
		'amountOfCells',
		'wormHole',
		'distributions',
		'length',
		'laps',
		'cardManager'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'configuring' }
GameBuilder >> allCellsWith: anEffect [

	distributions := { Distribution at: anEffect with: 1 }
]

{ #category : 'building' }
GameBuilder >> build [

	| board |
	board := Board
		         with: amountOfCells
		         and: wormHole
		         has: distributions
		         basedOn: length.
	^ Game
		  with: board
		  using: (DiceBucket with: dice)
		  andShipsNamed: shipNames
		  until: laps
		  cardManager: cardManager
]

{ #category : 'configuring' }
GameBuilder >> cells: anAmount [

	amountOfCells := anAmount
]

{ #category : 'configuring' }
GameBuilder >> deck: cards [

	cardManager := FixCardManager creation.
	cardManager addCardsToDeck: cards
]

{ #category : 'configuring' }
GameBuilder >> dice: aCollectionOfDice [

	dice := aCollectionOfDice
]

{ #category : 'configuring' }
GameBuilder >> diceSequence: numbers [

	dice := { LoadedDice withSequence: numbers }
]

{ #category : 'configuring' }
GameBuilder >> distributions: aCollectionOfDistributions [

	distributions := aCollectionOfDistributions
]

{ #category : 'initialization' }
GameBuilder >> initialize [

	super initialize.
	shipNames := #( 'ship 1' ).
	dice := { LoadedDice withSequence: #( 1 ) }.
	amountOfCells := 10.
	wormHole := Worm with: 2 and: 4.
	distributions := { Distribution at: NoEffect with: 1 }.
	length := Distance parsecs: 20.
	laps := 1.
	cardManager := CardManager creation
]

{ #category : 'configuring' }
GameBuilder >> laps: anAmount [

	laps := anAmount
]

{ #category : 'configuring' }
GameBuilder >> length: aDistance [

	length := aDistance
]

{ #category : 'configuring' }
GameBuilder >> shipsNamed: names [

	shipNames := names
]

{ #category : 'configuring' }
GameBuilder >> wormHoleBetween: aPosition and: anotherPosition [

	wormHole := Worm with: aPosition and: anotherPosition
]
