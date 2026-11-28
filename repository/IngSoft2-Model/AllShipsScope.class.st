Class {
	#name : 'AllShipsScope',
	#superclass : 'EffectScope',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'querying' }
AllShipsScope >> reversed [

	^ NoShipsScope new
]

{ #category : 'querying' }
AllShipsScope >> shipsAffectedWhen: aShip landsAmong: allShips [

	^ allShips
]
