Class {
	#name : 'Finished',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
Finished >> keepPlaying: aGame [

	^ self
]

{ #category : 'playing' }
Finished >> play: aGame [

	^ Error signal:
		  'The game has already been played, you can not play any more.'
]

{ #category : 'playing' }
Finished >> playTurnOf: aGame [

	^ Error signal:
		  'The game has already been played, you can not play any more.'
]

{ #category : 'playing' }
Finished >> rankingOf: aGame [

	^ aGame topShipNames
]

{ #category : 'playing' }
Finished >> ship: shipName useCard: aCard with: anotherShipName in: aGame [

	^ Error signal: 'Cards can not be played once the game has finished'
]

{ #category : 'playing' }
Finished >> showWinner: aGame [

	^ aGame currentTopPlayer
]

{ #category : 'as yet unclassified' }
Finished >> skipTurnOf: aGame [

	^ Error signal:
		  'The game has already been played, you can not play any more.'
]
