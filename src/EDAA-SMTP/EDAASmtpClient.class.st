Class {
	#name : #EDAASmtpClient,
	#superclass : #ZdcSecureSMTPClient,
	#traits : 'EDACPrintOnHelper + EDACLogging',
	#classTraits : 'EDACPrintOnHelper classTrait + EDACLogging classTrait',
	#instVars : [
		'pendingLog'
	],
	#category : #'EDAA-SMTP'
}

{ #category : #logging }
EDAASmtpClient class >> logDebugMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings debugEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'DEBUG'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAASmtpClient class >> logErrorMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings errorEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'ERROR'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAASmtpClient class >> logInfoMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings infoEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'INFO '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAASmtpClient class >> logTraceMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings traceEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'TRACE'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAASmtpClient class >> logWarningMessage: aMessage beautify: aBoolean [
	^ EDACLoggingSettings warningEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'WARN '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAASmtpClient >> flushPendingLog [
	self pendingLog ifNotNil: [ :col | col do: [ :line | self logDebugMessage: line beautify: false ] ].
	self pendingLog: OrderedCollection new
]

{ #category : #accessing }
EDAASmtpClient >> initialize [
	| result |
	result := super initialize.
	self pendingLog: OrderedCollection new.
	^ result
]

{ #category : #accessing }
EDAASmtpClient >> logVerbose: aString [
	self pendingLog ifEmpty: [ self pendingLog: OrderedCollection new ].
	self pendingLog add: aString
]

{ #category : #accessing }
EDAASmtpClient >> pendingLog [
	^ pendingLog
]

{ #category : #accessing }
EDAASmtpClient >> pendingLog: aCollection [
	pendingLog := aCollection
]

{ #category : #accessing }
EDAASmtpClient >> sendCommand: aString [
	| result |
	result := super sendCommand: aString.
	(aString = 'QUIT') ifTrue: [ self flushPendingLog ].
	^ result
]
