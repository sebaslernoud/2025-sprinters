Class {
	#name : 'EffectScopeTest',
	#superclass : 'TestCase',
	#instVars : [
		'ship1',
		'ship2',
		'ship3',
		'ships'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'running' }
EffectScopeTest >> setUp [

	super setUp.
	ship1 := Ship create: 'ship 1'.
	ship2 := Ship create: 'ship 2'.
	ship3 := Ship create: 'ship 3'.
	ships := { ship1. ship2. ship3 }
]

{ #category : 'tests' }
EffectScopeTest >> test000WhenTheScopeIsTheLandingShipThenItAffectsOnlyTheShipThatLanded [

	self
		assert: (LandingShipScope new shipsAffectedWhen: ship1 landsAmong: ships) asArray
		equals: { ship1 }
]

{ #category : 'tests' }
EffectScopeTest >> test001WhenTheScopeIsTheOtherShipsThenItAffectsEveryShipExceptTheOneThatLanded [

	self
		assert: (OtherShipsScope new shipsAffectedWhen: ship1 landsAmong: ships) asArray
		equals: { ship2. ship3 }
]

{ #category : 'tests' }
EffectScopeTest >> test002WhenTheScopeIsAllShipsThenItAffectsEveryShip [

	self
		assert: (AllShipsScope new shipsAffectedWhen: ship1 landsAmong: ships) asArray
		equals: ships
]

{ #category : 'tests' }
EffectScopeTest >> test003WhenTheScopeIsNoShipsThenItAffectsNobody [

	self assert: (NoShipsScope new shipsAffectedWhen: ship1 landsAmong: ships) isEmpty
]

{ #category : 'tests' }
EffectScopeTest >> test004WhenTheLandingShipScopeIsReversedThenItAffectsTheOtherShips [

	self
		assert: (LandingShipScope new reversed shipsAffectedWhen: ship1 landsAmong: ships) asArray
		equals: { ship2. ship3 }
]

{ #category : 'tests' }
EffectScopeTest >> test005WhenTheOtherShipsScopeIsReversedThenItAffectsOnlyTheShipThatLanded [

	self
		assert: (OtherShipsScope new reversed shipsAffectedWhen: ship1 landsAmong: ships) asArray
		equals: { ship1 }
]

{ #category : 'tests' }
EffectScopeTest >> test006WhenTheAllShipsScopeIsReversedThenItAffectsNobody [

	self assert: (AllShipsScope new reversed shipsAffectedWhen: ship1 landsAmong: ships) isEmpty
]

{ #category : 'tests' }
EffectScopeTest >> test007WhenTheNoShipsScopeIsReversedThenItAffectsEveryShip [

	self
		assert: (NoShipsScope new reversed shipsAffectedWhen: ship1 landsAmong: ships) asArray
		equals: ships
]

{ #category : 'tests' }
EffectScopeTest >> test008WhenAScopeIsReversedTwiceThenItAffectsTheSameShipsAsBefore [

	self
		assert: (LandingShipScope new reversed reversed shipsAffectedWhen: ship1 landsAmong: ships) asArray
		equals: { ship1 }
]
