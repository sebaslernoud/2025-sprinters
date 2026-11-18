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

	| ship |
	ship := self shipInTurnOrder.
	[ ship canPlay and: [ ship wantsToPlay ] ] whileFalse: [
		ship skipTurn.
		ship := self shipInTurnOrder ].
	^ ship
]

{ #category : 'as yet unclassified' }
TurnManager >> shipInTurnOrder [

	| ship |
	ship := ships at: turn.
	turn := turn \\ ships size + 1.
	^ ship
]

{ #category : 'playing' }
TurnManager >> skipTurnForShipNamed: shipName [	
	| shipFound |
	shipFound := self findShipBy: shipName.
	shipFound choiceToNotPlay.
]
