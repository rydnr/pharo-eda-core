Extension { #name : #VORepository }

{ #category : #'*EDAA-EventStore-Voyage' }
VORepository >> disableSingleton [
	self class setRepository: nil
]
