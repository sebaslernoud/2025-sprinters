Class {
	#name : 'ShipState',
	#superclass : 'Object',
	#instVars : [
		'bonusThrow',
		'mercenaries',
		'cards'
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

{ #category : 'accessing' }
ShipState >> cards [

	^ cards
]

{ #category : 'as yet unclassified' }
ShipState >> checkIfIHaveAsMercery: aShip [

	^ mercenaries anySatisfy: [ :ship | aShip = ship ]
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

	bonusThrow := 0.
	mercenaries := OrderedCollection new.
	cards := OrderedCollection new
]

{ #category : 'accessing' }
ShipState >> mercenaries [

	^ mercenaries
]

{ #category : 'as yet unclassified' }
ShipState >> payHelpToMyMercenariesWith: aDiceBucket [

	| count |
	count := 0.
	mercenaries do: [ :ship |
		count := count + (ship helpToFightWith: aDiceBucket) ].
	^ count + bonusThrow
]

{ #category : 'removing' }
ShipState >> removeCard: aCard [

	cards remove: aCard
]

{ #category : 'removing' }
ShipState >> removeMercenaries: aShip [

	mercenaries remove: aShip
]
