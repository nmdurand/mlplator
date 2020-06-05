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


sortedArrayContains = (array, word)->
	# Expecting word to already be normalized
	if array.length is 1
		if word is array[0]
			return true
		else
			return false
	else
		midIndex = Math.floor(array.length/2)

		normW1 = word
		normW2 = stringUtils.normalize array[midIndex]

		if normW1 is normW2
			return true
		else if normW1 < normW2
			tempArray = _.cloneDeep array
			await sortedArrayContains tempArray.splice(0, midIndex), word
		else if normW1 > normW2
			tempArray = _.cloneDeep array
			await sortedArrayContains tempArray.splice(midIndex, array.length-1), word


testAllCombinations = (fixedStr, letterArray, dictionary, startIndex = 0, endIndex)->
	unless endIndex?
		endIndex = dictionary.length-1
	# console.log '> Testing all combs', fixedStr, letterArray, startIndex, endIndex

	if letterArray.length is 0
		console.log '> Testing:', fixedStr
		isAWord = await sortedArrayContains dictionary, fixedStr
		if isAWord
			console.log '>> This is a word:', fixedStr
			[fixedStr]
		# else
		# 	console.log '>> Nope'
	else
		result = []
		usedLetters = []
		for letter, i in letterArray
			unless usedLetters.includes letter
				usedLetters.push letter # Avoid duplicates
				letterArrayMinusOne = _.cloneDeep letterArray
				letterArrayMinusOne.splice(i, 1)
				{ startIndex, endIndex } = reduceDictionary fixedStr+letter, dictionary, startIndex, endIndex
				subCombinations = await testAllCombinations(fixedStr+letter, letterArrayMinusOne, dictionary, startIndex, endIndex)
				if subCombinations?
					result = result.concat subCombinations
		result

reduceDictionary = (str, dictionary, startIndex, endIndex)->
	# console.log '> Reducing dictionary', str, startIndex, endIndex
	midIndex = Math.floor((startIndex+endIndex)/2)
	# console.log '> Comparing', str, 'with',dictionary[midIndex], midIndex
	if str is dictionary[midIndex]
		# console.log 'Dictionary kept as is.'
		result =
			startIndex: startIndex
			endIndex: endIndex
	else
		motAvant = str < dictionary[midIndex]
		if motAvant
			# console.log 'Reduced dictionary (head):'
			result =
				startIndex: startIndex
				endIndex: midIndex
		else
			# console.log 'Reduced dictionary (tail):'
			result =
				startIndex: midIndex
				endIndex: endIndex


# getWordArray().then (wordArray)->
# 	wordExists = await sortedArrayContains(wordArray, 'doleances')
# 	console.log '>> Test result:', wordExists


letters = 'E-I-A-E-S-C-F-C-F'
# letters = 'lte'
letters = stringUtils.normalize letters

getWordArray().then (dictionary)->
	letterArray = letters.split ''

	allCombinations = await testAllCombinations '', letterArray, dictionary
	console.log '>>>> MOTS TROUVÉS :', allCombinations
	# allCombinations = await getAllCombinations letterArray
	# # console.log '> Got all combinations', allCombinations
	# acceptedWords = []
	# resultPromise = Promise.resolve()
	# _.forEach allCombinations, (combination)->
	# 	word = combination.join ''
	# 	# console.log '> Testing word:', word
	# 	resultPromise = resultPromise.then ->
	# 		console.log '> Testing:', word
	# 		# if word is 'doleances'
	# 		wordExists = await sortedArrayContains(dictionaryArray, word)
	# 		if wordExists
	# 			console.log '>>>>>>>>>> Trouvé un mot :', word
	# 			acceptedWords.push word
	#
	# resultPromise = resultPromise.then ->
	# 	console.log '>>> Résultats:', acceptedWords...
