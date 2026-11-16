Class {
	#name : 'BattleManagerTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BattleManagerTest >> test001WhenTwoShipsFightAndShip2WinsThenShip1LoseBatle [

	| ship1 ship2 battleManager |
	ship1 := Ship create: 'ship 1'.
	ship2 := Ship create: 'ship 2'.
	battleManager := BattleManager with: (DiceBucket with: { LoadedDice withSequence: #( 6 9 ) }).
	battleManager fightBetween: ship1 and: ship2. "ship 1 saca 6, ship 2 saca 9"
	self assert: ship1 shields equals: 2.
	self assert: ship2 shields equals: 3
]
