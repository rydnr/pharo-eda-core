Class {
	#name : #EDAAProjectionMemoryRepository,
	#superclass : #EDAAProjectionVoyageRepository,
	#category : #'EDAA-Projections-Voyage'
}

{ #category : #accessing }
EDAAProjectionMemoryRepository >> configureAuthentication [

]

{ #category : #persistence }
EDAAProjectionMemoryRepository >> convertDictonaryToConditionalBlock: aDictionary [
	| aBlock |
	aBlock := [ :each | aDictionary associations allSatisfy: [ :association | (each perform: association key asSymbol) = association value ] ].
	^ aBlock
]

{ #category : #persistence }
EDAAProjectionMemoryRepository >> initBackendRepository [
	| result |
	result := VOMemoryRepository new.
	result enableSingleton.
	^ result
]

{ #category : #persistence }
EDAAProjectionMemoryRepository >> selectMany: aProjectionClass where: aDictionary [
	^ aProjectionClass selectMany: (self convertDictonaryToConditionalBlock: aDictionary)
]

{ #category : #persistence }
EDAAProjectionMemoryRepository >> selectOne: aProjectionClass where: aDictionary [
	^ aProjectionClass selectOne: (self convertDictonaryToConditionalBlock: aDictionary)
]
