fs = require 'fs'
_ = require 'lodash'
stringUtils = require './string'

wordListPath = require 'french-wordlist'

getWordArray = ->
	new Promise (resolve, reject)->
		fs.readFile wordListPath, 'utf8', (err,data)->
			if err
				reject err
			else
				resolve data.split '\n'

getAllCombinations = (array)->
	# console.log '> Getting all combs', array
	if array.length is 1
		array
	else
		result = []
		usedLetters = []
		for letter, i in array
			unless usedLetters.includes letter
				usedLetters.push letter # Avoid duplicates
				tempArray = _.cloneDeep array
				tempArray.splice(i, 1)
				subCombinations = await getAllCombinations(tempArray)
				result.push _.map(subCombinations, (result)-> _.concat letter, result)...
		result

letters = 'MNRAEOLMENT'

letters = stringUtils.normalize letters
letterArray = letters.split ''

getWordArray().then (wordArray)->
	dictionary = {}
	resultPromise = Promise.resolve()
	_.forEach wordArray, (word)->
		resultPromise = resultPromise.then ->
			normalizedWord = stringUtils.normalize word
			dictionary[normalizedWord] = word


	resultPromise = resultPromise.then ->
		console.log '>>> Dictionary object is populated'

	allCombinations = await getAllCombinations letterArray
	acceptedWords = []
	_.forEach allCombinations, (combination)->
		word = combination.join ''
		resultPromise = resultPromise.then ->
			await setTimeout (->
				if dictionary[word]?
					console.log '>>>>>>>>>> Trouvé un mot :', word
					acceptedWords.push dictionary[word]), 0

	resultPromise = resultPromise.then ->
		console.log '>>> Résultats:', acceptedWords...
