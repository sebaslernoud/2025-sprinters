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
Game class >> with: aBoard using: aDiceBucket andShipsNamed: shipNames cardManager: aCardManager [

	shipNames ifEmpty: [ ^ Error signal: 'List of ships must not be empty.' ].
	self validateUniqueNames: shipNames.
	^ self new
		  initializeWith: aBoard
		  using: aDiceBucket
		  andShipsNamed: shipNames
		  cardManager: aCardManager
]

{ #category : 'playing' }
Game >> applyAccelerationCardEffect [
	ships do: [:ship | ship increaseBonusThrow  ].
]

{ #category : 'accessing' }
Game >> cardManager [

	^ cardManager
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
	aShip mercenaries do: [ :mercenary | self damage: mercenary ]
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

{ #category : 'initialization' }
Game >> initializeWith: aBoard using: aDiceBucket andShipsNamed: shipNames cardManager: aCardManager [

	board := aBoard.
	ships := shipNames collect: [ :shipName | Ship create: shipName ].
	bucketOfDices := aDiceBucket.
	status := Started new.
	turnManager := TurnManager with: ships.
	battleManager := BattleManager with: aDiceBucket.
	effectManager := EffectManager creation.
	cardManager := aCardManager.
	ships do: [ :ship | cardManager drawInitialCardsFor: ship ]
]

{ #category : 'playing' }
Game >> keepPlaying [

	status keepPlaying: self
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
	board move: currentShip by: (bucketOfDices rollFor: currentShip).
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

{ #category : 'as yet unclassified' }
Game >> resolveShipNamed: shipName useCard: aCard with: anotherShipName [

	cardManager
		playCard: aCard
		by: (self findShipBy: shipName)
		target: (self findShipBy: anotherShipName)
		in: self
]

{ #category : 'as yet unclassified' }
Game >> sendAllShipsToStart [

	ships do: [ :ship | board moveToStart: ship ]
]

{ #category : 'playing' }
Game >> shipNamed: shipName useCard: aCard with: anotherShipName [

	status ship: shipName useCard: aCard with: anotherShipName in: self
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
