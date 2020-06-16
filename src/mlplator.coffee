fs = require 'fs'
_ = require 'lodash'
stringUtils = require './string'

wordListPath = require 'french-wordlist'
CHUNK_SIZE = 1000

getNormalizedLetterArray  = (string)->
	normalizedString = stringUtils.normalize string
	normalizedString.split ''

getWordArray = ->
	new Promise (resolve, reject)->
		fs.readFile wordListPath, 'utf8', (err,data)->
			if err
				reject err
			else
				resolve data.split '\n'

getDictionaryObject = (wordArray)->
	dictionary = {}
	dictionaryPromise = Promise.resolve()
	_.forEach wordArray, (word)->
		dictionaryPromise = dictionaryPromise.then ->
			normalizedWord = stringUtils.normalize word
			dictionary[normalizedWord] = word
			dictionary
	dictionaryPromise


getAllCombinations = (array)->
	new Promise (resolve, reject)->
		if array.length is 1
			resolve array
		else
			result = []
			usedLetters = []
			resultPromise = Promise.resolve()
			_.forEach array, (letter, i)->
				unless usedLetters.includes letter
					usedLetters.push letter # Avoid duplicates
					resultPromise = resultPromise.then ->
						tempArray = _.cloneDeep array
						tempArray.splice(i, 1)
						subCombinations = await getAllCombinations(tempArray)
						result.push _.map(subCombinations, (result)-> _.concat letter, result)...
			resultPromise = resultPromise.then ->
				resolve result

# getAllCombinationsSync = (array)->
# 	new Promise (resolve, reject)->
# 		if array.length is 1
# 			resolve array
# 		else
# 			result = []
# 			usedLetters = []
# 			resultPromise = Promise.resolve()
# 			_.forEach array, (letter, i)->
# 				unless usedLetters.includes letter
# 					usedLetters.push letter # Avoid duplicates
# 					resultPromise = resultPromise.then ->
# 						new Promise (resolve, reject)->
# 							tempArray = _.cloneDeep array
# 							tempArray.splice(i, 1)
# 							subCombinations =
# 								setImmediate ->
# 									await getAllCombinations(tempArray)
# 									result.push _.map(subCombinations, (result)-> _.concat letter, result)...
# 									console.log '> Got results:', result
# 									resolve result
# 			resultPromise = resultPromise.then (result)->
# 				resolve result

isWordInDictionary = (word, dictionary)->
	new Promise (resolve, reject)->
		if dictionary[word]?
			console.log '>>>>>>>>>> Mot trouvé !'
			resolve dictionary[word]
		else
			resolve()


((string)->

	wordArray = await getWordArray()
	dictionary = await getDictionaryObject(wordArray)
	console.log '>>> Dictionary object is populated, size is:', wordArray.length, 'entries'

	letterArray = getNormalizedLetterArray string
	allCombinations = await getAllCombinations letterArray

	console.log 'Number of combinations:', allCombinations.length
	processAll = (combinations, dictObject)->
		resultPromise = Promise.resolve()
		foundWords = []
		_.forEach combinations, (combination)->
			word = combination.join ''
			resultPromise = resultPromise.then ->
				isWordInDictionary(word, dictObject).then (wordResult)->
					if wordResult?
						foundWords.push wordResult
					foundWords

		resultPromise = resultPromise.then (allResults)->
			console.log '>>> Résultats:', (_.filter allResults, (result)-> not _.isEmpty result)...

	# processChunk = (combinations, dictObject)->
	# 	resultPromise = []
	# 	_.forEach combinations, (combination)->
	# 		word = combination.join ''
	# 		resultPromise.push isWordInDictionary word, dictObject
	#
	# 	Promise.all(resultPromise).then (allResults)->
	# 		console.log '>>> Résultats:', (_.filter allResults, (result)-> not _.isEmpty result)...
	#
	# processCombinations = (remainingCombinations, dictObject)->
	# 	console.log '> Remaining cominations to process:', remainingCombinations.length
	# 	if remainingCombinations.length < CHUNK_SIZE
	# 		processChunk remainingCombinations, dictObject
	# 	else
	# 		combinationsChunk = remainingCombinations.splice 0, CHUNK_SIZE
	# 		processChunk combinationsChunk, dictObject
	# 		setImmediate (-> processCombinations(remainingCombinations, dictObject))

	processAll allCombinations, dictionary


) 'puraaplies'
