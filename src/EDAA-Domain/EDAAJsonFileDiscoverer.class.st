Class {
	#name : #EDAAJsonFileDiscoverer,
	#superclass : #Object,
	#instVars : [
		'jsonFile',
		'candidates'
	],
	#category : #'EDAA-Domain'
}

{ #category : #'instance creation' }
EDAAJsonFileDiscoverer class >> forJsonFile: aFile [
	^ self new jsonFile: aFile; yourself
]

{ #category : #accessing }
EDAAJsonFileDiscoverer >> candidates [
	^ candidates
		ifNil: [ self candidates: (self processJsonFile: self jsonFile).
						candidates ]
]

{ #category : #accessing }
EDAAJsonFileDiscoverer >> candidates: anObject [
	candidates := anObject
]

{ #category : #accessing }
EDAAJsonFileDiscoverer >> jsonFile [
	^ jsonFile
]

{ #category : #accessing }
EDAAJsonFileDiscoverer >> jsonFile: anObject [
	jsonFile := anObject
]

{ #category : #accessing }
EDAAJsonFileDiscoverer >> processJsonFile: aFile [
	| result map |
	result := OrderedCollection new.
	map := (NeoJSONReader on: aFile name readStream) parseMap.
	map
		keysAndValuesDo: [ :k :v | 
			result
				add:
					(EDAACandidate withKey: k value: v) ].
	^ result
]
