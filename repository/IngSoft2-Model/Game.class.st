Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'bucketOfDices',
		'ships',
		'status',
		'turnManager',
		'battleManager',
		'cardManager',
		'effectManager'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Game class >> validateUniqueNames: shipNames [

	shipNames asSet size = shipNames size ifFalse: [
		^ Error signal: 'Ship´s name must not be reapeated.' ].
	^ shipNames
]

{ #category : 'as yet unclassified' }
Game class >> with: aBoard using: aDiceBucket andShipsNamed: shipNames deck: aDeck [

	shipNames ifEmpty: [ ^ Error signal: 'List of ships must not be empty.' ].
	self validateUniqueNames: shipNames.
	^ self new
		  initializeWith: aBoard
		  using: aDiceBucket
		  andShipsNamed: shipNames
		  deck: aDeck
]

{ #category : 'cards' }
Game >> activate: anActiveCard [

	cardManager activate: anActiveCard
]

{ #category : 'cards' }
Game >> activeCards [

	^ cardManager activeCards
]

{ #category : 'rolling' }
Game >> areAllied: aShip with: anotherShip [

	^ ((self mercenariesOf: aShip) includes: anotherShip) or: [
		  (self mercenariesOf: anotherShip) includes: aShip ]
]

{ #category : 'cards' }
Game >> cancel: anActiveCard [

	cardManager cancel: anActiveCard
]

{ #category : 'accessing' }
Game >> cardsOf: aShipName [

	^ (cardManager handOf: (self findShipBy: aShipName)) copy
]

{ #category : 'converting' }
Game >> cellsIn: aDistance [

	^ board cellsIn: aDistance
]

{ #category : 'accessing' }
Game >> currentTopPlayer [

	^ self shipsSortedByPosition at: 1.
]

{ #category : 'as yet unclassified' }
Game >> damage: aShip [

	aShip loseShield.
	aShip isDefenseless ifTrue: [ self penalize: aShip ]
]

{ #category : 'as yet unclassified' }
Game >> damageAllShips [

	ships do: [ :ship | self damage: ship ]
]

{ #category : 'battle' }
Game >> defeat: aShip [

	board moveToStart: aShip.
	self damage: aShip.
	(self mercenariesOf: aShip) do: [ :mercenary | self damage: mercenary ]
]

{ #category : 'as yet unclassified' }
Game >> effectManager [

	^ effectManager
]

{ #category : 'accessing' }
Game >> findShipBy: aName [

	^ ships detect: [ :ship | ship name = aName ]
]

{ #category : 'private' }
Game >> finish [

	status := Finished new
]

{ #category : 'dealing' }
Game >> giveCardTo: aShip [

	cardManager giveCardTo: aShip
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard using: aDiceBucket andShipsNamed: shipNames deck: aDeck [

	board := aBoard.
	ships := shipNames collect: [ :shipName | Ship create: shipName ].
	bucketOfDices := aDiceBucket.
	status := Started new.
	turnManager := TurnManager with: ships.
	battleManager := BattleManager new.
	effectManager := EffectManager creation.
	cardManager := CardManager with: aDeck.
	ships do: [ :ship | cardManager dealInitialCardsTo: ship ]
]

{ #category : 'playing' }
Game >> keepPlaying [

	status keepPlaying: self
]

{ #category : 'cards' }
Game >> lastPlayedCard [

	^ cardManager lastPlayedCard
]

{ #category : 'rolling' }
Game >> mercenariesOf: aShip [

	^ cardManager mercenariesOf: aShip
]

{ #category : 'as yet unclassified' }
Game >> move: aShip by: anAmountOfCells [

	board move: aShip by: anAmountOfCells
]

{ #category : 'as yet unclassified' }
Game >> moveAllShipsExcept: aShip by: anAmountOfCells [

	(ships copyWithout: aShip) do: [ :ship |
		board move: ship by: anAmountOfCells ]
]

{ #category : 'private' }
Game >> penalize: aShip [

	turnManager penalize: aShip turns: 2.
	aShip restoreShields
]

{ #category : 'playing' }
Game >> play [

	status play:self.

	^ 'Game over'
]

{ #category : 'playing' }
Game >> playNextTurn [

	| currentShip |
	currentShip := turnManager nextShip.
	board move: currentShip by: (self rollFor: currentShip).
	(currentShip winAt: board) ifTrue: [ ^ self finish ].
	effectManager
		apply: (board effectOnPosition: currentShip position)
		to: currentShip
		in: self.
	battleManager resolveIfNeededAt: currentShip in: self.
	self someShipWon
]

{ #category : 'playing' }
Game >> playTurn [

	status playTurnOf: self
]

{ #category : 'cards' }
Game >> repeatLastEffectOn: aShip [

	effectManager lastRealEffect applyTo: aShip in: self
]

{ #category : 'private' }
Game >> resolveShip: aShipName plays: aCard targeting: aTarget [

	cardManager
		play: aCard
		by: (self findShipBy: aShipName)
		targeting: aTarget
		in: self
]

{ #category : 'rolling' }
Game >> rollFor: aShip [

	^ bucketOfDices throw + (cardManager bonusFor: aShip)
]

{ #category : 'as yet unclassified' }
Game >> sendAllShipsToStart [

	ships do: [ :ship | board moveToStart: ship ]
]

{ #category : 'cards' }
Game >> ship: aShipName plays: aCard [

	self ship: aShipName plays: aCard targeting: aShipName
]

{ #category : 'cards' }
Game >> ship: aShipName plays: aCard targeting: aTarget [

	status ship: aShipName plays: aCard targeting: aTarget in: self
]

{ #category : 'accessing' }
Game >> ships [
	^ ships
]

{ #category : 'accessing' }
Game >> shipsSortedByPosition [

	^ ships copy sort: [ :a :b | a isAheadOf: b ]
]

{ #category : 'accessing' }
Game >> showRanking [

	^ status rankingOf: self
]

{ #category : 'playing' }
Game >> showShipsPositions [

	| result |
	result := Dictionary new.
	ships do: [ :ship | result at: ship name put: ship position ].
	^ result
]

{ #category : 'accessing' }
Game >> showWinner [

	^ status showWinner: self
]

{ #category : 'private' }
Game >> skipNextTurn [

	turnManager nextShip restoreShields
]

{ #category : 'playing' }
Game >> skipTurn [

	status skipTurnOf: self
]

{ #category : 'playing' }
Game >> someShipWon [

	(ships anySatisfy: [ :ship | ship winAt: board ]) ifTrue: [ self finish ]
]

{ #category : 'as yet unclassified' }
Game >> teleport: aShip to: aCell [

	board teleport: aShip to: aCell
]

{ #category : 'playing' }
Game >> topShipNames [

	^ ((self shipsSortedByPosition first: (3 min: ships size)) collect: [
		   :ship | ship name ]) asOrderedCollection
]

{ #category : 'cards' }
Game >> validateIsAvailableAsMercenary: aShip [

	(cardManager isHired: aShip) ifTrue: [
		^ Error signal: 'You can not use this ship as a mercenary' ]
]

{ #category : 'cards' }
Game >> validateTurnOf: aShip [

	turnManager shipInTurn == aShip ifFalse: [
		^ Error signal: 'Permanent cards can only be played during your turn' ]
]
