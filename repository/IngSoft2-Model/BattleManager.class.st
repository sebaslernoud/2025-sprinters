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

{ #category : 'private' }
BattleManager >> defeat: aShip in: aGame [

	aGame sendToStart: aShip.
	aGame damage: aShip.
	(aGame mercenariesOf: aShip) do: [ :mercenary | aGame damage: mercenary ]
]

{ #category : 'playing' }
BattleManager >> fightBetween: shipA and: shipB in: aGame [

	| resultA resultB |
	[
	resultA := self battleRollOf: shipA in: aGame.
	resultB := self battleRollOf: shipB in: aGame.
	resultA = resultB ] whileTrue.
	self
		defeat: (resultA > resultB
				 ifTrue: [ shipB ]
				 ifFalse: [ shipA ])
		in: aGame
]

{ #category : 'playing' }
BattleManager >> resolveBattlesOf: aShip in: aGame [

	((aGame shipsAt: aShip location) copyWithout: aShip) do: [ :enemy |
		(self shouldFight: aShip with: enemy in: aGame) ifTrue: [
			self fightBetween: aShip and: enemy in: aGame ] ]
]

{ #category : 'private' }
BattleManager >> shouldFight: aShip with: anEnemy in: aGame [

	^ aShip location = anEnemy location and: [
		  (aGame areAllied: aShip with: anEnemy) not ]
]
