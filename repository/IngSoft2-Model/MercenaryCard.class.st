Class {
	#name : 'MercenaryCard',
	#superclass : 'Card',
	#instVars : [
		'linkedShip',
		'mercenary'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
MercenaryCard class >> with: aShip [

	mercenary := aShip
]

{ #category : 'playing' }
MercenaryCard >> applyTo: aShip using: aMercenary in: aGame [

	(aGame cardManager isValidMercenary: aMercenary in: aGame ships)
		ifFalse: [ Error signal: 'You can not use this ship as a mercenary' ].
	linkedShip := aShip.
	mercenary := aMercenary.
	aShip addMercenary: aMercenary
]

{ #category : 'testing' }
MercenaryCard >> isPermanent [

	^ true
]

{ #category : 'removing' }
MercenaryCard >> removePermanentEffect [

	linkedShip removeMercenary: mercenary
]
