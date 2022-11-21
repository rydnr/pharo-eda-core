Class {
	#name : #EDAAJsonFileDiscovererTest,
	#superclass : #TestCase,
	#instVars : [
		'tempJsonFile'
	],
	#category : #'EDAA-Domain-Tests'
}

{ #category : #running }
EDAAJsonFileDiscovererTest >> setUp [
	super setUp.
	tempJsonFile := File named: ((FileSystem workingDirectory
		/ (self class printString , '.json')) nextVersion)
]

{ #category : #running }
EDAAJsonFileDiscovererTest >> tearDown [
	tempJsonFile ifNotNil: [ :f | f name delete ].
	super tearDown
]

{ #category : #tests }
EDAAJsonFileDiscovererTest >> testParseAFlatJsonFile [
	| fileContents discoverer |
	fileContents := '{
  "sample": "value"
}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := EDAAJsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isNotEmpty;
		assert: discoverer candidates size equals: 1;
		assert: discoverer candidates first isNotNil;
		assert: discoverer candidates first key equals: 'sample';
		assert: discoverer candidates first value equals: 'value'

]

{ #category : #tests }
EDAAJsonFileDiscovererTest >> testParseAnEmptyJsonFile [
	| fileContents discoverer |
	fileContents := '{}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := EDAAJsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isEmpty
]

{ #category : #tests }
EDAAJsonFileDiscovererTest >> testParseAnotherFlatJsonFile [
	| fileContents discoverer |
	fileContents := '{
  "candidate1": "value1",
  "candidate2": "value2"
}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := EDAAJsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isNotEmpty;
		assert: discoverer candidates size equals: 2;
		assert: discoverer candidates first isNotNil;
		assert: discoverer candidates first key equals: 'candidate1';
		assert: discoverer candidates first value equals: 'value1';
		assert: discoverer candidates second isNotNil;
		assert: discoverer candidates second key equals: 'candidate2';
		assert: discoverer candidates second value
			equals: 'value2'
]

{ #category : #tests }
EDAAJsonFileDiscovererTest >> testParseCommandListenerAdapterInJsonFile [
	| fileContents discoverer commandListener |
	fileContents := '{
  "commandListener": {
    "host": "localhost",
    "port": 61613,
    "user": "user",
    "password": "secret",
    "queue": "messages-to-eda",
    "durable": true,
    "ack": "client-individual",
    "prefetchCount": 1,
    "timeout": 60,
    "debug": true,
    "restartOnError": false
  }
}'.
	self write: fileContents toFile: tempJsonFile.
	discoverer := EDAAJsonFileDiscoverer forJsonFile: tempJsonFile.
	self
		assert: discoverer isNotNil;
		assert: discoverer candidates isNotEmpty;
		assert: discoverer candidates size equals: 1;
		assert: discoverer candidates first isNotNil.
	commandListener := discoverer candidates first.
	self
		assert: commandListener isNotNil;
		assert: commandListener key equals: 'commandListener';
		assert: (commandListener value at: 'host') equals: 'localhost';
		assert: (commandListener value at: 'port') equals: 61613;
		assert: (commandListener value at: 'user') equals: 'user';
		assert: (commandListener value at: 'password') equals: 'secret';
		assert: (commandListener value at: 'queue')
			equals: 'messages-to-eda';
		assert: (commandListener value at: 'durable') equals: true;
		assert: (commandListener value at: 'ack')
			equals: 'client-individual';
		assert: (commandListener value at: 'prefetchCount') equals: 1;
		assert: (commandListener value at: 'timeout') equals: 60;
		assert: (commandListener value at: 'debug') equals: true;
		assert: (commandListener value at: 'restartOnError') equals: false
]

{ #category : #helpers }
EDAAJsonFileDiscovererTest >> write: aString toFile: aFile [
	aFile name
		writeStreamDo: [ :stream | stream nextPutAll: aString ]
]
