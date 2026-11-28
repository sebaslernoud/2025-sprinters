Class {
	#name : 'ReversePolarityCard',
	#superclass : 'PermanentCard',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
ReversePolarityCard >> activeCardBy: aShip targeting: aCell in: aGame [

	aGame validateCellExists: aCell.
	^ ActiveReversePolarity on: aCell
]
