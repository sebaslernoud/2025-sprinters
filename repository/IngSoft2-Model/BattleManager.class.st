Class {
	#name : 'BattleManager',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'private' }
BattleManager >> battleRollOf: aShip in: aGame [

	^ (aGame mercenariesOf: aShip)
		  inject: (aGame rollFor: aShip)
		  into: [ :total :mercenary | total + (aGame rollFor: mercenary) ]
]

{ #category : 'playing' }
BattleManager >> fightBetween: shipA and: shipB in: aGame [

	| resultA resultB |
	[
	resultA := self battleRollOf: shipA in: aGame.
	resultB := self battleRollOf: shipB in: aGame.
	resultA = resultB ] whileTrue.
	aGame defeat: (resultA > resultB
			 ifTrue: [ shipB ]
			 ifFalse: [ shipA ])
]

{ #category : 'playing' }
BattleManager >> resolveIfNeededAt: actualShip in: aGame [

	(aGame ships select: [ :ship |
		 ship ~~ actualShip and: [ ship location = actualShip location ] ])
		do: [ :enemy |
			(aGame areAllied: actualShip with: enemy) ifFalse: [
				self fightBetween: actualShip and: enemy in: aGame ] ]
]
