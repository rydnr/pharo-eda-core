Class {
	#name : #EDAAMongoNoCache,
	#superclass : #VOCache,
	#category : #'EDAA-EventStore-Voyage'
}

{ #category : #accessing }
EDAAMongoNoCache >> at: anOID put: anObject [
	"Do nothing"
]

{ #category : #accessing }
EDAAMongoNoCache >> keyAtValue: anObject [
	"Do nothing"
	^ nil

]

{ #category : #accessing }
EDAAMongoNoCache >> keyAtValue: anObject ifAbsent: aBlock [
	"Do nothing"

	^ nil
]
