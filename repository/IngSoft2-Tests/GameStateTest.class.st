Class {
	#name : 'GameStateTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameStateTest >> test000WhenGameIsNotPlayedThenPlayingStateIsFalse [

	| gameState |
	gameState := Started new.
	 self assert: gameState isFinished equals: false
]

{ #category : 'tests' }
GameStateTest >> test004WhenGameIsFinishedThenFinishedStateIsTrue [

	| gameState |
	gameState := Finished new.
	self assert: gameState isFinished equals: true
]

{ #category : 'tests' }
GameStateTest >> test007WhenGameIsFinishedAndAskForWinnerThenReturnWinner [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 10 );
		         build.
	aGame play.
	self assert: aGame showWinner name equals: 'ship 1'
]

{ #category : 'tests' }
GameStateTest >> test008WhenGameIsNotPlayedAndAskForWinnerThenRaiseError [

	| aGame |
	aGame := GameBuilder new build.
	self
		should: [ aGame showWinner ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'The game is not finished, so it hasn´t a winner yet' ]
]

{ #category : 'tests' }
GameStateTest >> test009WhenGamePlaysOneTurnThenOnlyTheShipInTurnMoves [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 5 );
		         build.
	aGame playTurn.
	self assert: (aGame findShipBy: 'ship 1') position equals: 6.
	self assert: (aGame findShipBy: 'ship 2') position equals: 1
]
