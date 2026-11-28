Class {
	#name : 'EffectManager',
	#superclass : 'Object',
	#instVars : [
		'lastApplication'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'applying' }
EffectManager >> apply: anEffect to: aShip in: aGame [

	| concreteEffect |
	concreteEffect := anEffect effectFor: aShip.
	lastApplication := EffectApplication
		                   of: concreteEffect
		                   within: (aGame scopeOf: concreteEffect landedAt: aShip position).
	lastApplication applyLandedBy: aShip in: aGame
]

{ #category : 'initialization' }
EffectManager >> initialize [

	super initialize.
	lastApplication := EffectApplication of: NoEffect new within: NoShipsScope new
]

{ #category : 'as yet unclassified' }
EffectManager >> repeatLastEffectOn: aShip in: aGame [

	lastApplication applyLandedBy: aShip in: aGame
]
