*omnibase
evaluateAndCommitIn: anOmniBaseTransaction
		"Evaluate the receiver block while setting the current transaction 
		to anOmniBaseTransaction. If an error occurs during execution of
		this block the transaction will be rolled back. If there is no error the
		transaction will be committed. Answer the result of evaluating the block."

	| activeProcess previousTxn result |
	activeProcess := Processor activeProcess.
	previousTxn := OmniBase getCurrentAndSet: anOmniBaseTransaction for: activeProcess.
	[result := self ifCurtailed: [anOmniBaseTransaction abort].
	anOmniBaseTransaction commit]
		ensure: [
			previousTxn isNil
				ifTrue: [OmniBase removeFor: activeProcess]
				ifFalse: [OmniBase setTransaction: previousTxn for: activeProcess]].
	^result