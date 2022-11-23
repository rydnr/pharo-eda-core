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
