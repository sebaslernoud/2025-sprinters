Class {
	#name : 'EffectApplication',
	#superclass : 'Object',
	#instVars : [
		'effect',
		'scope'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
EffectApplication class >> of: anEffect within: aScope [

	^ self new initializeOf: anEffect within: aScope
]

{ #category : 'as yet unclassified' }
EffectApplication >> applyLandedBy: aShip in: aGame [

	(scope shipsAffectedWhen: aShip landsAmong: aGame allShips) do: [ :ship |
		effect affect: ship in: aGame ]
]

{ #category : 'initialization' }
EffectApplication >> initializeOf: anEffect within: aScope [

	effect := anEffect.
	scope := aScope
]
