Class {
	#name : 'EffectScope',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'converting' }
EffectScope >> reversed [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
EffectScope >> shipsAffectedWhen: aShip landsAmong: allShips [

	self subclassResponsibility
]
