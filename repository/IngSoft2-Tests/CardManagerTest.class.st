Class {
	#name : 'CardManagerTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CardManagerTest >> test000WhenNoReversePolarityIsActiveThenNoCellIsReversed [

	| cardManager |
	cardManager := CardManager with: (FixedDeck with: #(  )).
	self deny: (cardManager isReversed: 7)
]

{ #category : 'tests' }
CardManagerTest >> test001WhenAReversePolarityIsActiveOnACellThenOnlyThatCellIsReversed [

	| cardManager |
	cardManager := CardManager with: (FixedDeck with: #(  )).
	cardManager activate: (ActiveReversePolarity on: 7).
	self assert: (cardManager isReversed: 7).
	self deny: (cardManager isReversed: 8)
]

{ #category : 'tests' }
CardManagerTest >> test002WhenTwoReversePolarityAreActiveOnTheSameCellThenItIsNotReversed [

	| cardManager |
	cardManager := CardManager with: (FixedDeck with: #(  )).
	cardManager activate: (ActiveReversePolarity on: 7).
	cardManager activate: (ActiveReversePolarity on: 7).
	self deny: (cardManager isReversed: 7)
]

{ #category : 'tests' }
CardManagerTest >> test003WhenOneOfTwoReversePolarityOnTheSameCellIsCancelledThenItIsReversedAgain [

	| cardManager firstReversePolarity |
	cardManager := CardManager with: (FixedDeck with: #(  )).
	firstReversePolarity := ActiveReversePolarity on: 7.
	cardManager activate: firstReversePolarity.
	cardManager activate: (ActiveReversePolarity on: 7).
	cardManager cancel: firstReversePolarity.
	self assert: (cardManager isReversed: 7)
]

{ #category : 'tests' }
CardManagerTest >> test004WhenReversePolarityIsActiveOnTwoDifferentCellsThenBothAreReversed [

	| cardManager |
	cardManager := CardManager with: (FixedDeck with: #(  )).
	cardManager activate: (ActiveReversePolarity on: 7).
	cardManager activate: (ActiveReversePolarity on: 3).
	self assert: (cardManager isReversed: 7).
	self assert: (cardManager isReversed: 3)
]
