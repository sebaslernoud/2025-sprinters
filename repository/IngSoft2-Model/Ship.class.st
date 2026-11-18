Class {
	#name : 'Ship',
	#superclass : 'Object',
	#instVars : [
		'position',
		'name',
		'currentLap',
		'state',
		'location'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Ship class >> create: aName [

	aName isString ifFalse: [
		^ Error signal: 'Ship´s name must be a string.' ].

	^ self new initializeWith: aName
]

{ #category : 'adding' }
Ship >> addMercenary: aShip [

	state addMercenary: aShip
]

{ #category : 'playing' }
Ship >> bonusThrow [

	^ state bonusThrow
]

{ #category : 'testing' }
Ship >> canPlay [

	^ state canIPlay
]

{ #category : 'playing' }
Ship >> cards [

	^ state cards
]

{ #category : 'playing' }
Ship >> choiceToNotPlay [

	^ state chooseToNotPlay
]

{ #category : 'playing' }
Ship >> decreaseBonusThrow [

	state decreaseBonus
]

{ #category : 'testing' }
Ship >> hasAsMercery: aShip [

	^ state checkIfIHaveAsMercery: aShip
]

{ #category : 'testing' }
Ship >> hasCard: aCard [

	^ state hasThisCard: aCard
]

{ #category : 'playing' }
Ship >> helpToFightWith: aDiceBucket [

	^ aDiceBucket throw
]

{ #category : 'playing' }
Ship >> increaseBonusThrow [

	state increaseBonus
]

{ #category : 'initialization' }
Ship >> initializeWith: aName [

	name := aName.
	location := Location cell: 1 lap: 1.
	state := ShipState creation
]

{ #category : 'testing' }
Ship >> isAheadOf: anotherShip [

	^ location isAheadOf: anotherShip location
]

{ #category : 'accessing' }
Ship >> laps [

	^ location lap
]

{ #category : 'accessing' }
Ship >> location [

	^ location
]

{ #category : 'playing' }
Ship >> loseFight [

	self moveTo: location atStart.
	state loseFight
]

{ #category : 'playing' }
Ship >> loseShield [

	state loseShield
]

{ #category : 'path commands' }
Ship >> moveTo: aLocation [

	location := aLocation
]

{ #category : 'accessing' }
Ship >> name [

	^ name
]

{ #category : 'accessing' }
Ship >> position [

	^ location cell
]

{ #category : 'playing' }
Ship >> receiveCard: aCard [

	state add: aCard
]

{ #category : 'playing' }
Ship >> recoverShields [

	state recoverShields
]

{ #category : 'removing' }
Ship >> removeCard: aCard [

	state removeCard: aCard
]

{ #category : 'removing' }
Ship >> removeMercenary: aShip [

	state removeMercenaries: aShip
]

{ #category : 'accessing' }
Ship >> shields [

	^ state shields
]

{ #category : 'playing' }
Ship >> skipTurn [

	state reduceTurnsToSkip
]

{ #category : 'playing' }
Ship >> throwDicesWith: aDiceBucket [

	| result helper |
	result := aDiceBucket throw.
	helper := state payHelpToMyMercenariesWith: aDiceBucket.
	^ result + helper
]

{ #category : 'accessing' }
Ship >> turnsThatHasToSkip [

	^ state turnsToSkip
]

{ #category : 'accessing' }
Ship >> wantsToPlay [

	^ state optionalTurn
]

{ #category : 'playing' }
Ship >> winAt: aBoard [

	^ aBoard isTheFinish: location
]
