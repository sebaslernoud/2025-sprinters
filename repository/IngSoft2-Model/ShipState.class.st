Class {
	#name : 'ShipState',
	#superclass : 'Object',
	#instVars : [
		'turnsToSkip',
		'optionalTurn',
		'bonusThrow',
		'mercenaries',
		'cards',
		'shields'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
ShipState class >> creation [

	^ self new initialization
]

{ #category : 'adding' }
ShipState >> add: aCard [

	cards add: aCard
]

{ #category : 'adding' }
ShipState >> addMercenary: aShip [

	mercenaries add: aShip
]

{ #category : 'accessing' }
ShipState >> bonusThrow [

	^ bonusThrow
]

{ #category : 'testing' }
ShipState >> canIPlay [

	^ turnsToSkip = 0
]

{ #category : 'accessing' }
ShipState >> cards [

	^ cards
]

{ #category : 'as yet unclassified' }
ShipState >> checkIfIHaveAsMercery: aShip [

	^ mercenaries anySatisfy: [ :ship | aShip = ship ]
]

{ #category : 'as yet unclassified' }
ShipState >> chooseToNotPlay [

	self recoverShields.
	turnsToSkip := turnsToSkip + 1
]

{ #category : 'as yet unclassified' }
ShipState >> decreaseBonus [

	bonusThrow := bonusThrow - 1
]

{ #category : 'as yet unclassified' }
ShipState >> hasThisCard: aCard [

	^ cards anySatisfy: [ :card | card = aCard ]
]

{ #category : 'as yet unclassified' }
ShipState >> increaseBonus [

	bonusThrow := bonusThrow + 1
]

{ #category : 'initialization' }
ShipState >> initialization [

	turnsToSkip := 0.
	optionalTurn := true.
	bonusThrow := 0.
	mercenaries := OrderedCollection new.
	shields := 3.
	cards := OrderedCollection new
]

{ #category : 'as yet unclassified' }
ShipState >> loseFight [

	mercenaries do: [ :mercenaryShip | mercenaryShip loseShield ].
	self loseShield
]

{ #category : 'playing' }
ShipState >> loseShield [

	shields := shields - 1.
	shields = 0 ifFalse: [ ^ self ].

	self recoverShields.
	turnsToSkip := 2
]

{ #category : 'accessing' }
ShipState >> optionalTurn [

	^ optionalTurn
]

{ #category : 'as yet unclassified' }
ShipState >> payHelpToMyMercenariesWith: aDiceBucket [

	| count |
	count := 0.
	mercenaries do: [ :ship |
		count := count + (ship helpToFightWith: aDiceBucket) ].
	^ count + bonusThrow
]

{ #category : 'playing' }
ShipState >> recoverShields [

	shields := 3.
	turnsToSkip :=0.
	optionalTurn :=true.
]

{ #category : 'as yet unclassified' }
ShipState >> reduceTurnsToSkip [

	turnsToSkip := turnsToSkip - 1
]

{ #category : 'removing' }
ShipState >> removeCard: aCard [

	cards remove: aCard
]

{ #category : 'removing' }
ShipState >> removeMercenaries: aShip [

	mercenaries remove: aShip
]

{ #category : 'accessing' }
ShipState >> shields [

	^ shields
]

{ #category : 'accessing' }
ShipState >> turnsToSkip [

	^ turnsToSkip
]
