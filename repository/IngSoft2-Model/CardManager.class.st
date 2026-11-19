Class {
	#name : 'CardManager',
	#superclass : 'Object',
	#instVars : [
		'deck',
		'activeCards',
		'discardPile',
		'hands'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
CardManager class >> with: aDeck [

	^ self new initializeWith: aDeck
]

{ #category : 'as yet unclassified' }
CardManager >> activePermanentCards [

	^ activeCards
]

{ #category : 'as yet unclassified' }
CardManager >> applyRedoEffectOn: aShip in: aGame [

	| realCard |
    discardPile isEmpty ifTrue: [
        ^ Error signal: 'There are no cards played before.'
    ].
    realCard := discardPile reversed
        detect: [ :card | card isRedo not ]
        ifNone: [ ^ Error signal: 'No real card to redo.' ].

    realCard applyTo: aShip using: aShip in: aGame.
]

{ #category : 'as yet unclassified' }
CardManager >> cancelCard: aCard [

	| card |
	card := activeCards
		        detect: [ :c | c matches: aCard ]
		        ifNone: [
		        Error signal: 'No active card matches the one to cancel' ].
	card removePermanentEffect.
	activeCards remove: card
]

{ #category : 'dealing' }
CardManager >> dealInitialCardsTo: aShip [

	2 timesRepeat: [ self giveCardTo: aShip ]
]

{ #category : 'dealing' }
CardManager >> giveCardTo: aShip [

	(self handOf: aShip) add: deck draw
]

{ #category : 'dealing' }
CardManager >> handOf: aShip [

	^ hands at: aShip ifAbsentPut: [ OrderedCollection new ]
]

{ #category : 'testing' }
CardManager >> hasActiveCard: aCard [

	^ activeCards anySatisfy: [ :each | each matches: aCard ]
]

{ #category : 'initialization' }
CardManager >> initializeWith: aDeck [

	deck := aDeck.
	hands := IdentityDictionary new.
	activeCards := OrderedCollection new.
	discardPile := OrderedCollection new
]

{ #category : 'testing' }
CardManager >> isValidMercenary: aShip in: ships [

	^ ships noneSatisfy: [ :ship | ship hasAsMercery: aShip ]
]

{ #category : 'as yet unclassified' }
CardManager >> playCard: aCard by: aShip target: aShip2 in: aGame [

	((self handOf: aShip) includes: aCard) ifFalse: [
		Error signal: 'Cannot play a card you do not have' ].
	(aCard isCancellationCard and: [ self activePermanentCards isEmpty ])
		ifTrue: [
			self error:
				'Cannot play cancellation card with no active permanent cards' ].
	aCard applyTo: aShip using: aShip2 in: aGame.
	(self handOf: aShip) remove: aCard.
	self registerCard: aCard
]

{ #category : 'as yet unclassified' }
CardManager >> registerCard: aCard [
	discardPile add:aCard.
    (aCard isPermanent )ifTrue:[ activeCards add: aCard ]
]
