Class {
	#name : 'AccelerationCard',
	#superclass : 'PermanentCard',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
AccelerationCard >> activeCardBy: aShip targeting: aTarget in: aGame [

	^ ActiveAcceleration new
]
