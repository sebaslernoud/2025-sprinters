Class {
	#name : 'LandingShipScope',
	#superclass : 'EffectScope',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'converting' }
LandingShipScope >> reversed [

	^ OtherShipsScope new
]

{ #category : 'as yet unclassified' }
LandingShipScope >> shipsAffectedWhen: aShip landsAmong: allShips [

	^ { aShip }
]
