Class {
	#name : #EDACommandMaterializer,
	#superclass : #Object,
	#traits : 'EDACLogging',
	#classTraits : 'EDACLogging classTrait',
	#instVars : [
		'edaApplication'
	],
	#category : #'EDA-Commands-Materializers'
}

{ #category : #'instance creation' }
EDACommandMaterializer class >> forApplication: anEDAApplication [

	^ self new
		  edaApplication: anEDAApplication;
		  yourself
]

{ #category : #logging }
EDACommandMaterializer class >> logDebugMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings debugEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'DEBUG'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDACommandMaterializer class >> logErrorMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings errorEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'ERROR'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDACommandMaterializer class >> logInfoMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings infoEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'INFO '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDACommandMaterializer class >> logTraceMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings traceEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'TRACE'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDACommandMaterializer class >> logWarningMessage: aMessage beautify: aBoolean [
	^ EDACLoggingSettings warningEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'WARN '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #parsing }
EDACommandMaterializer >> commandClassForName: aCommandName [

	^ self edaApplication commandClassPrefix
	  ,
		  (aCommandName copyWithRegex: '_' matchesReplacedWith: ' ')
			  asLowercase asCamelCase
]

{ #category : #parsing }
EDACommandMaterializer >> commandClassPrefix [
	self subclassResponsibility
]

{ #category : #accessing }
EDACommandMaterializer >> edaApplication [

	^ edaApplication
]

{ #category : #accessing }
EDACommandMaterializer >> edaApplication: anObject [

	edaApplication := anObject
]

{ #category : #parsing }
EDACommandMaterializer >> materialize: aString [
	self subclassResponsibility
]
