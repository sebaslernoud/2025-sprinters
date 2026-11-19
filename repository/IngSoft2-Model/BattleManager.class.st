Class {
	#name : 'BattleManager',
	#superclass : 'Object',
	#instVars : [
		'diceBucket'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
BattleManager class >> with: aDiceBucket [

	^ self new initializeWith: aDiceBucket
]

{ #category : 'playing' }
BattleManager >> fightBetween: shipA and: shipB in: aGame [

	| resultA resultB |
	[
	resultA := shipA throwDicesWith: diceBucket.
	resultB := shipB throwDicesWith: diceBucket.
	resultA = resultB ] whileTrue.
	aGame defeat: (resultA > resultB
			 ifTrue: [ shipB ]
			 ifFalse: [ shipA ])
]

{ #category : 'initialization' }
BattleManager >> initializeWith: aDiceBucket [

	diceBucket := aDiceBucket
]

{ #category : 'accessing' }
BattleManager >> resolveIfNeededAt: actualShip in: aGame [

	| shipsInSameLocation |
	shipsInSameLocation := aGame ships select: [ :ship |
		                       ship ~~ actualShip and: [
			                       ship location = actualShip location ] ].
	shipsInSameLocation do: [ :enemy |
		((actualShip hasAsMercery: enemy) or: [
			 enemy hasAsMercery: actualShip ]) ifFalse: [
			self fightBetween: actualShip and: enemy in: aGame ] ]
]
