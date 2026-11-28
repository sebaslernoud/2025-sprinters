Class {
	#name : 'BattleManagerTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BattleManagerTest >> test001WhenTwoShipsFightAndShip2WinsThenShip1LoseBatle [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 3 3 9 6 );
		         wormHoleBetween: 9 and: 10;
		         build.
	aGame playTurn. "ship 1 cae en 4"
	aGame playTurn. "ship 2 cae en 4 y pelean: ship 2 saca 9, ship 1 saca 6"
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
BattleManagerTest >> test002WhenTheArrivingShipLosesItsFirstBattleThenItDoesNotFightTheOtherShipsInTheCell [

	| mercenaryCard aGame |
	mercenaryCard := MercenaryCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 3 3 3 1 2 2 );
		         wormHoleBetween: 9 and: 10;
		         deck: { mercenaryCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard targeting: 'ship 2'.
	aGame playTurn. "ship 1 cae en 4"
	aGame playTurn. "ship 2 cae en 4: es mercenaria de ship 1, no pelean"
	aGame playTurn.
	"ship 3 cae en 4 y pelea con ship 1: saca 1 contra 2 + 2 de su mercenaria.
	 Pierde y va a la largada: ya no esta en la celda 4, asi que no pelea con ship 2"
	self assert: (aGame positionOf: 'ship 3') equals: 1.
	self assert: (aGame shieldsOf: 'ship 3') equals: 2.
	self assert: (aGame positionOf: 'ship 2') equals: 4.
	self assert: (aGame shieldsOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
BattleManagerTest >> test003WhenTheArrivingShipWinsItsFirstBattleThenItKeepsFightingTheOtherShipsInTheCell [

	| mercenaryCard aGame |
	mercenaryCard := MercenaryCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 3 3 3 6 1 1 5 1 );
		         wormHoleBetween: 9 and: 10;
		         deck: { mercenaryCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard targeting: 'ship 2'.
	aGame playTurn. "ship 1 cae en 4"
	aGame playTurn. "ship 2 cae en 4: es mercenaria de ship 1, no pelean"
	aGame playTurn.
	"ship 3 cae en 4 y pelea con ship 1: saca 6 contra 1 + 1 de su mercenaria.
	 Gana: ship 1 va a la largada y pierde un escudo, y ship 2 (su mercenaria) tambien.
	 ship 3 sigue en la celda 4, asi que pelea con ship 2: 5 contra 1, y gana otra vez"
	self assert: (aGame positionOf: 'ship 3') equals: 4.
	self assert: (aGame shieldsOf: 'ship 3') equals: 3.
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame positionOf: 'ship 2') equals: 1.
	self assert: (aGame shieldsOf: 'ship 2') equals: 1
]
