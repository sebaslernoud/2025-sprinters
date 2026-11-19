Class {
	#name : 'ShipState',
	#superclass : 'Object',
	#instVars : [
		'bonusThrow',
		'mercenaries'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
ShipState class >> creation [

	^ self new initialization
]

{ #category : 'adding' }
ShipState >> addMercenary: aShip [

	mercenaries add: aShip
]

{ #category : 'accessing' }
ShipState >> bonusThrow [

	^ bonusThrow
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
ShipState >> increaseBonus [

	bonusThrow := bonusThrow + 1
]

{ #category : 'initialization' }
ShipState >> initialization [

	bonusThrow := 0.
	mercenaries := OrderedCollection new
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
ShipState >> removeMercenaries: aShip [

	mercenaries remove: aShip
]
