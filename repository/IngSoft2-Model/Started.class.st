Class {
	#name : 'Started',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
Started >> keepPlaying: aGame [

	aGame playTurn.
	aGame keepPlaying
]

{ #category : 'playing' }
Started >> play: aGame [

	aGame keepPlaying
]

{ #category : 'playing' }
Started >> playTurnOf: aGame [

	aGame playNextTurn
]

{ #category : 'playing' }
Started >> rankingOf: aGame [

	^ Error signal:
		  'The Game has not been played yet so it doesn`t have a ranking'
]

{ #category : 'playing' }
Started >> ship: shipName useCard: aCard with: anotherShipName in: aGame [

	aGame resolveShipNamed: shipName useCard: aCard with: anotherShipName
]

{ #category : 'playing' }
Started >> showWinner: aGame [

	^ Error signal: 'The game is not finished, so it hasn´t a winner yet'
]

{ #category : 'as yet unclassified' }
Started >> skipTurnOf: aGame [

	aGame skipNextTurn
]
