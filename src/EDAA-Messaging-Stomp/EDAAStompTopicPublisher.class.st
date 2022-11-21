"
* Class: EDAStompTopicPublisher

Communicates with Stomp exchanges to publish messages.

* Responsibility: 

Contains the configuration needed to publish messages to exchanges.
"
Class {
	#name : #EDAAStompTopicPublisher,
	#superclass : #EDAPTopicPublisher,
	#traits : 'EDACLogging',
	#classTraits : 'EDACLogging classTrait',
	#instVars : [
		'client'
	],
	#classInstVars : [
		'username',
		'routingKey',
		'password',
		'exchange',
		'durable',
		'host',
		'port',
		'timeout',
		'errorExchange',
		'errorRoutingKey'
	],
	#category : #'EDAA-Messaging-Stomp'
}

{ #category : #logging }
EDAAStompTopicPublisher class >> logDebugMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings debugEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'DEBUG'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAAStompTopicPublisher class >> logErrorMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings errorEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'ERROR'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAAStompTopicPublisher class >> logInfoMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings infoEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'INFO '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAAStompTopicPublisher class >> logTraceMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings traceEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'TRACE'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAAStompTopicPublisher class >> logWarningMessage: aMessage beautify: aBoolean [
	^ EDACLoggingSettings warningEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'WARN '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #'instance creation' }
EDAAStompTopicPublisher class >> withConfig: aConfig [
	| result |
	result := self new.
	result config: aConfig.
	result client: (result buildClientWith: aConfig).
	^ result
]

{ #category : #initialization }
EDAAStompTopicPublisher >> buildClientWith: config [

	| result |
	result := StampClient new.
	result login: config user.
	result passcode: config password.
	result host: config host.
	result port: config port.
	result timeout: config timeout.
	^ result
]

{ #category : #private }
EDAAStompTopicPublisher >> buildIdUsingClient: aClient withConfig: config [
	^ aClient nextId , '-', config exchange, config routingKey
]

{ #category : #accessing }
EDAAStompTopicPublisher >> client [
	^ client
]

{ #category : #accessing }
EDAAStompTopicPublisher >> client: val [
	client := val
]

{ #category : #accessing }
EDAAStompTopicPublisher >> destination [
	^ self destinationWithRoutingKey: self routingKey
]

{ #category : #accessing }
EDAAStompTopicPublisher >> destinationWithRoutingKey: key [
	^ '/exchange/', self exchange, '/', key
]

{ #category : #accessing }
EDAAStompTopicPublisher >> errorDestination [
	^ '/exchange/' , self errorExchange , '/#'
]

{ #category : #initialization }
EDAAStompTopicPublisher >> initialize [
	super initialize.
	"self client: (self buildClientWith: self class)"

]

{ #category : #logging }
EDAAStompTopicPublisher >> logMessagePublished: message usingClient: aClient on: aDestination [
	self
		logInfoMessage:
			'Published message ' , message greaseString , ' in '
				, aDestination greaseString , '.'
]

{ #category : #logging }
EDAAStompTopicPublisher >> logPublishingMessage: message usingClient: aClient on: aDestination [
	self
		logInfoMessage: 'Publishing message in ' , aDestination greaseString , '.'
]

{ #category : #private }
EDAAStompTopicPublisher >> nextId [
	^ self buildIdUsingClient: self client withConfig: self class
]

{ #category : #API }
EDAAStompTopicPublisher >> publishError: aMessage [
	^ self
		publishError: true
		message: aMessage
		usingClient: self client
		withConfig: self class
]

{ #category : #API }
EDAAStompTopicPublisher >> publishError: isError message: aMessage usingClient: aClient withConfig: config [
	| sendFrame destination |
	destination := isError
		ifTrue: [ config errorDestination ]
		ifFalse: [ config destination ].
	self
		logPublishingMessage: aMessage
		usingClient: aClient
		on: destination.
	aClient isConnected
		ifFalse: [ aClient open ].
	[
	sendFrame := StampSendFrame new.
	sendFrame destination: destination.
	sendFrame text: aMessage.
	sendFrame persistent: config durable.
	aClient writeWithReceipt: sendFrame.
	self
		logMessagePublished: aMessage
		usingClient: aClient
		on: destination ]
		ensure: [ aClient close ]
]

{ #category : #API }
EDAAStompTopicPublisher >> publishMessage: aMessage [
	^ self
		publishError: false message: aMessage
		usingClient: self client
		withConfig: self class
]

{ #category : #API }
EDAAStompTopicPublisher >> publishMessage: aMessage inTransaction: transactionId [
	^ self publishMessage: aMessage inTransaction: transactionId usingClient: self client withConfig: self class
]

{ #category : #API }
EDAAStompTopicPublisher >> publishMessage: aMessage inTransaction: transactionId usingClient: aClient withConfig: config [
	| sendFrame destination |
	self
		logPublishingMessage: aMessage
		usingClient: aClient
		on: config destination.
	destination := config destination.
	(sendFrame := StampSendFrame new)
		text: aMessage;
		destination: config destination;
		persistent: config durable;
		timeout: config timeout;
		transaction: transactionId.
	aClient writeWithReceipt: sendFrame.
	self
		logMessagePublished: aMessage
		usingClient: aClient
		on: destination
]

{ #category : #API }
EDAAStompTopicPublisher >> publishMessage: aMessage withRoutingKey: aRoutingKeyString [
	^ self publishMessage: aMessage withRoutingKey: aRoutingKeyString usingClient: self client withConfig: self class
]

{ #category : #API }
EDAAStompTopicPublisher >> publishMessage: aMessage withRoutingKey: aRoutingKeyString usingClient: aClient withConfig: config [
	| sendFrame destination |
	destination := config destinationWithRoutingKey: aRoutingKeyString.
	self
		logPublishingMessage: aMessage
		usingClient: aClient
		on: destination.
	aClient isConnected
		ifFalse: [ aClient open ].
	[ sendFrame := StampSendFrame new.
	sendFrame destination: destination.
	sendFrame text: aMessage.
	sendFrame persistent: config durable.
	aClient writeWithReceipt: sendFrame.
	self
		logMessagePublished: aMessage
		usingClient: aClient
		on: destination ]
		ensure: [ aClient close ]
]

{ #category : #API }
EDAAStompTopicPublisher >> publishMessages: messageCollection inTransaction: transactionId usingClient: aClient withConfig: config [
	| beginFrame commitFrame |
	aClient isConnected
		ifFalse: [ aClient open ].
	[ 
	beginFrame := StampBeginFrame transaction: transactionId.
	aClient writeWithReceipt: beginFrame.
	messageCollection
		do: [ :message | 
			self
				publishMessage: message
				inTransaction: transactionId
				usingClient: aClient
				withConfig: config ].
	commitFrame := StampCommitFrame transaction: transactionId.
	aClient writeWithReceipt: commitFrame ]
		ensure: [ aClient close ]
]

{ #category : #API }
EDAAStompTopicPublisher >> publishMessagesAtomically: messageCollection [
	^ self publishMessages: messageCollection inTransaction: self nextId usingClient: self client withConfig
]
