extends Node2D

func onclick():
	var contract = CoinFlipContract.new()
	await contract.coinFlipGuess("0x79C98d93f8222E21a798A2d486D7686776fca6ca")
	var result = await contract.consecutiveWins()
	print(result)
	#contract = PrecompliedAddressContract.new()
	#logs = await contract.getSeiAddr("0xa604362acaae026a0d326dfaed506186d1c145c8")
	#print(logs)
	pass
