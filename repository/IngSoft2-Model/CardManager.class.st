Class {
	#name : 'CardManager',
	#superclass : 'Object',
	#instVars : [
		'deck',
		'activeCards',
		'discardPile'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
CardManager class >> creation [

	^ self new initialization
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

{ #category : 'accessing' }
CardManager >> deck [

	^ deck
]

{ #category : 'as yet unclassified' }
CardManager >> drawCard [

	| index randomCard typeOfCards |
	typeOfCards := {
		               AccelerationCard.
		               SpeedCard.
		               CancellationCard.
		               MercenaryCard.
		               RedoCard.
		               RepeatCard.
		               SpeedCard }.
	index := Random new nextIntegerBetween: 1 and: typeOfCards size.
	randomCard := (typeOfCards at: index) new.
	^ randomCard
]

{ #category : 'as yet unclassified' }
CardManager >> drawCardOn: aShip [

	| card |
	card := self drawCard.
	aShip receiveCard: card
]

{ #category : 'as yet unclassified' }
CardManager >> drawInitialCardsFor: aShip [

	| card |
	self drawCardOn: aShip.
	self drawCardOn: aShip
]

{ #category : 'testing' }
CardManager >> hasActiveCard: aCard [

	^ activeCards anySatisfy: [ :each | each matches: aCard ]
]

{ #category : 'initialization' }
CardManager >> initialization [

	deck := OrderedCollection new.
	discardPile :=OrderedCollection new.
	activeCards := OrderedCollection new.
]

{ #category : 'testing' }
CardManager >> isValidMercenary: aShip in: ships [

	^ ships noneSatisfy: [ :ship | ship hasAsMercery: aShip ]
]

{ #category : 'as yet unclassified' }
CardManager >> playCard: aCard by: aShip target: aShip2 in: aGame [

	(aShip hasCard: aCard) ifFalse: [
		Error signal: 'Cannot play a card you do not have' ].

	(aCard isCancellationCard and: [ self activePermanentCards isEmpty ])
		ifTrue: [
			self error:
				'Cannot play cancellation card with no active permanent cards' ].

	aCard applyTo: aShip using: aShip2 in: aGame.
	aShip removeCard: aCard.
	self registerCard: aCard
]

{ #category : 'as yet unclassified' }
CardManager >> registerCard: aCard [
	discardPile add:aCard.
    (aCard isPermanent )ifTrue:[ activeCards add: aCard ]
]
