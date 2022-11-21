Extension { #name : #TStampFrameWithBody }

{ #category : #'*EDAA-Messaging-Stomp' }
TStampFrameWithBody >> contentType [
	^ self headerAt: #'content-type' ifAbsent: [ self headerAt: #'Content-Type' ifAbsent: [ 'application/json' ]]
]

{ #category : #'*EDAA-Messaging-Stomp' }
TStampFrameWithBody >> text: string [
	self
		contentType: 'application/json';
		body: string
]
