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
Game class >> with: aBoard using: aDiceBucket andShipsNamed: shipNames until: laps cardManager: aCardManager [

	shipNames ifEmpty: [ ^ Error signal: 'List of ships must not be empty.' ].
	self validateUniqueNames: shipNames.
	^ self new
		  initializeWith: aBoard
		  using: aDiceBucket
		  andShipsNamed: shipNames
		  until: laps
		  cardManager: aCardManager
]

{ #category : 'playing' }
Game >> applyAccelerationCardEffect [
	ships do: [:ship | ship increaseBonusThrow  ].
]

{ #category : 'playing' }
Game >> applyAtomicEffectOn: aShip [

	ships do: [ :ship |
		ship moveToPosition: 1.
		ship loseShield ]
]

{ #category : 'playing' }
Game >> applyMoonWalkEffectOn: aShip moving: numberOfCells [
	 ships do: [ :otherShip |
		otherShip ~~ aShip ifTrue: [
			otherShip move: numberOfCells * -1 in: board ] ].
]

{ #category : 'accessing' }
Game >> board [

	^ board
]

{ #category : 'accessing' }
Game >> cardManager [

	^ cardManager
]

{ #category : 'accessing' }
Game >> currentTopPlayer [

	^ self shipsSortedByPosition at: 1.
]

{ #category : 'as yet unclassified' }
Game >> effectManager [

	^ effectManager
]

{ #category : 'accessing' }
Game >> findShipBy: aName [

	^ ships detect: [ :ship | ship name = aName ]
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard using: diceBucket andShipsNamed: shipsname until: laps cardManager: aCardManager [

	board := aBoard with: laps.
	ships := shipsname collect: [ :ship | Ship create: ship ].
	bucketOfDices := diceBucket.
	status := Started new.
	turnManager := TurnManager with: ships.
	battleManager := BattleManager with: diceBucket.
	effectManager := EffectManager creation.
	cardManager := aCardManager.
	ships do: [ :ship | cardManager drawInitialCardsFor: ship ]
]

{ #category : 'playing' }
Game >> keepPlaying [

	status keepPlaying: self
]

{ #category : 'playing' }
Game >> play [

	status play:self.

	^ 'Game over'
]

{ #category : 'playing' }
Game >> playNextTurn [

	| currentShip rolledDistance boardEffect |
	currentShip := turnManager nextShip.
	rolledDistance := bucketOfDices rollFor: currentShip.
	currentShip move: rolledDistance in: board.
	boardEffect := board effectOnPosition: currentShip position.
	effectManager apply: boardEffect to: currentShip in: self.
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

{ #category : 'playing' }
Game >> skipTurnForShipNamed: shipName [ 
	turnManager skipTurnForShipNamed: shipName.
]

{ #category : 'playing' }
Game >> someShipWon [

	(ships anySatisfy: [ :ship | ship winAt: board ]) ifTrue: [
		status := Finished new ]
]

{ #category : 'playing' }
Game >> topShipNames [

	^ ((self shipsSortedByPosition first: (3 min: ships size)) collect: [
		   :ship | ship name ]) asOrderedCollection
]
