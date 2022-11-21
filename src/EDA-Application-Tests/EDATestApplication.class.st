Class {
	#name : #EDATestApplication,
	#superclass : #EDAApplication,
	#category : #'EDA-Application-Tests'
}

{ #category : #subclassresponsibility }
EDATestApplication >> commandClassPrefix [
	^ self shouldBeImplemented
]

{ #category : #subclassresponsibility }
EDATestApplication >> eventClassPrefix [
	^ self shouldBeImplemented
]

{ #category : #'reset - events' }
EDATestApplication >> resetEventSubscriptions [
	^ self shouldBeImplemented
]

{ #category : #'setup - events' }
EDATestApplication >> setupEventSubscriptions [
	^ self shouldBeImplemented
]
