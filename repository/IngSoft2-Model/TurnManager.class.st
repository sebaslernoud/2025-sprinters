Class {
	#name : 'TurnManager',
	#superclass : 'Object',
	#instVars : [
		'ships',
		'turn'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
TurnManager class >> with: ships [

	ships isEmpty ifTrue: [
		^ Error signal: 'Ships must to have one item at least' ].
	^ self new initializeWith: ships
]

{ #category : 'accessing' }
TurnManager >> findShipBy: shipName [

	^ ships detect: [ :ship | ship name = shipName ]
]

{ #category : 'initialization' }
TurnManager >> initializeWith: shipCollection [

	turn := 1.
	ships := shipCollection
]

{ #category : 'playing' }
TurnManager >> nextShip [

	| totalShips turnsSkipped ship |
	totalShips := ships size.
	turnsSkipped := 0.

	[ turnsSkipped < totalShips ] whileTrue: [
		ship := ships at: turn.
		turn := turn \\ totalShips + 1.
		(ship canPlay and: [ ship wantsToPlay ])
			ifTrue: [ ^ ship ]
			ifFalse: [
				ship skipTurn.
				turnsSkipped := turnsSkipped + 1 ] ].
	Error signal: 'There is no ship witch can play'
]

{ #category : 'playing' }
TurnManager >> skipTurnForShipNamed: shipName [	
	| shipFound |
	shipFound := self findShipBy: shipName.
	shipFound choiceToNotPlay.
]
