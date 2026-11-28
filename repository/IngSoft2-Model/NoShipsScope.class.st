Class {
	#name : 'NoShipsScope',
	#superclass : 'EffectScope',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'converting' }
NoShipsScope >> reversed [

	^ AllShipsScope new
]

{ #category : 'as yet unclassified' }
NoShipsScope >> shipsAffectedWhen: aShip landsAmong: allShips [

	^ #(  )
]
