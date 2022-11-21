Class {
	#name : #EDAAProjectionMongoRepository,
	#superclass : #EDAAProjectionVoyageRepository,
	#traits : 'EDACMongoHelper',
	#classTraits : 'EDACMongoHelper classTrait',
	#classInstVars : [
		'password',
		'wireProtocolEnabled',
		'lazySynchronize',
		'forceEager',
		'ensuringCurrentReferencesOnQueries',
		'ensuringCurrentOnSave',
		'enableSingleton',
		'debug',
		'enableReplication',
		'host',
		'port',
		'authenticationMechanism',
		'urls',
		'tls',
		'database',
		'user'
	],
	#category : #'EDAA-Projections-Voyage'
}

{ #category : #accessing }
EDAAProjectionMongoRepository class >> authenticationMechanism [
	^ authenticationMechanism
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> authenticationMechanism: anObject [
	authenticationMechanism := anObject
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> database [

	^ database
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> database: val [

	database := val
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> debug [
	^ debug
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> debug: aBoolean [
	debug = aBoolean
		ifTrue: [ ^ self ].
	debug := aBoolean.
	self refreshVoyageSettings
]

{ #category : #'class initialization' }
EDAAProjectionMongoRepository class >> doInitialize [

	self urls: nil.
	self tls: nil.
	self database: nil.
	self user: nil.
	self password: nil.
	self debug: nil.
	self enableReplication: nil.
	self enableSingleton: nil.
	self ensuringCurrentOnSave: nil.
	self ensuringCurrentReferencesOnQueries: nil.
	self forceEager: nil.
	self lazySynchronize: nil.
	self wireProtocolEnabled: nil
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> enableReplication [
	^ enableReplication
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> enableReplication: aBoolean [
	enableReplication = aBoolean
		ifTrue: [ ^ self ].
	enableReplication := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> enableSingleton [
	^ enableSingleton
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> enableSingleton: aBoolean [
	enableSingleton = aBoolean
		ifTrue: [ ^ self ].
	enableSingleton := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> ensuringCurrentOnSave [
	^ ensuringCurrentOnSave
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> ensuringCurrentOnSave: aBoolean [
	ensuringCurrentOnSave = aBoolean
		ifTrue: [ ^ self ].
	ensuringCurrentOnSave := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> ensuringCurrentReferencesOnQueries [
	^ ensuringCurrentReferencesOnQueries
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> ensuringCurrentReferencesOnQueries: aBoolean [
	ensuringCurrentReferencesOnQueries = aBoolean
		ifTrue: [ ^ self ].
	ensuringCurrentReferencesOnQueries := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> forceEager [
	^ forceEager
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> forceEager: aBoolean [
	forceEager = aBoolean
		ifTrue: [ ^ self ].
	forceEager := aBoolean.
	self refreshVoyageSettings
]

{ #category : #'class initialization' }
EDAAProjectionMongoRepository class >> initialize [
	self doInitialize
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> lazySynchronize [
	^ lazySynchronize
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> lazySynchronize: aBoolean [
	lazySynchronize = aBoolean
		ifTrue: [ ^ self ].
	lazySynchronize := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> password [
	^ password
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> password: val [
	password := val
]

{ #category : #'refresh settings' }
EDAAProjectionMongoRepository class >> refreshVoyageSettings [
	EDAAVOProjectionMongoRepository allInstancesDo: [ :repo | self refreshVoyageSettingsOn: repo ]
]

{ #category : #'refresh settings' }
EDAAProjectionMongoRepository class >> refreshVoyageSettingsOn: aRepository [

	aRepository user: self user.
	aRepository password: self password.
	aRepository debug: self debug.
	self enableReplication
		ifTrue: [ aRepository enableReplication ]
		ifFalse: [ aRepository disableReplication ].
	aRepository ensuringCurrentOnSave: self ensuringCurrentOnSave.
	aRepository ensuringCurrentReferencesOnQueries:
		self ensuringCurrentReferencesOnQueries.
	aRepository lazySynchronize: self lazySynchronize.
	self enableSingleton
		ifTrue: [ aRepository enableSingleton ]
		ifFalse: [ aRepository disableSingleton ].
	aRepository wireProtocolEnabled: self wireProtocolEnabled
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> tls [
	^ tls
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> tls: aBoolean [
	tls := aBoolean
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> urls [
	^ urls
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> urls: aString [
	urls := aString
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> user [

	^ user
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> user: anObject [

	user := anObject
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> wireProtocolEnabled [
	^ wireProtocolEnabled
]

{ #category : #accessing }
EDAAProjectionMongoRepository class >> wireProtocolEnabled: aBoolean [
	wireProtocolEnabled = aBoolean
		ifTrue: [ ^ self ].
	wireProtocolEnabled := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAProjectionMongoRepository >> configureAuthentication [
	self flag: #TODO.	"Find out how to customize the authentication of the specific Mongo instance"
	self class authenticationMechanism beDefault.

]

{ #category : #persistence }
EDAAProjectionMongoRepository >> mongoRepositoryClass [
	^ EDAAVOProjectionMongoRepository
]
