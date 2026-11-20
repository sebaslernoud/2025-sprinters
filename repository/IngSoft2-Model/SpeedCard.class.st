Class {
	#name : 'SpeedCard',
	#superclass : 'PermanentCard',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
SpeedCard >> activeCardBy: aShip targeting: aShipName in: aGame [

	^ ActiveSpeed on: (aGame findShipBy: aShipName)
]
