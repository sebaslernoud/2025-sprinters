Class {
	#name : 'OtherShipsScope',
	#superclass : 'EffectScope',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'converting' }
OtherShipsScope >> reversed [

	^ LandingShipScope new
]

{ #category : 'as yet unclassified' }
OtherShipsScope >> shipsAffectedWhen: aShip landsAmong: allShips [

	^ allShips copyWithout: aShip
]
