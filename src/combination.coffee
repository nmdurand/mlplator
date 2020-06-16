
_ = require 'lodash'
stringUtils = require './string'

getNormalizedLetterArray  = (string)->
	normalizedString = stringUtils.normalize string
	normalizedString.split ''

CALL_STACK_LIMIT = 100000
callCount = 0

getAllCombinations = (array)->
	# console.log '> Getting all combinations:', array, callCount
	new Promise (resolve, reject)->
		if array.length is 1
			resolve array
		else
			if callCount > CALL_STACK_LIMIT
				console.log '>>>> STACK LIMIT REACHED, waiting...'
				setTimeout ->
					console.log '<<<< DONE WAITING...'
					callCount = 0
					result = await getAllCombinations array
					console.log '<<<< AND DONE AGAIN...'
					resolve result
			else
				result = []
				usedLetters = []
				resultPromise = Promise.resolve()
				_.forEach array, (letter, i)->
					unless usedLetters.includes letter
						callCount += 1
						usedLetters.push letter # Avoid duplicates
						resultPromise = resultPromise.then ->
							tempArray = _.cloneDeep array
							tempArray.splice(i, 1)
							subCombinations = await getAllCombinations(tempArray)
							result.push _.map(subCombinations, (result)-> _.concat letter, result)...
				resultPromise = resultPromise.then ->
					resolve result

# getAllCombinationsSync = (array)->
# 	console.log '> Call for array combinations of:', array
# 	new Promise (resolve, reject)->
# 		if array.length is 1
# 			resolve array
# 		else
# 			setImmediate ->
# 				result = []
# 				usedLetters = []
# 				subCombPromises = []
# 				_.forEach array, (letter, i)->
# 					unless usedLetters.includes letter
# 						# console.log '>> Taking care of letter:', letter
# 						usedLetters.push letter # Avoid duplicates
# 						tempArray = _.cloneDeep array
# 						tempArray.splice(i, 1)
# 						# console.log '> Calling:', tempArray
# 						subCombPromises.push getAllCombinationsSync(tempArray).then (subCombinations)->
# 							# console.log '> Got subcombinations:', subCombinations
# 							result.push _.map(subCombinations, (result)-> _.concat letter, result)...
# 				Promise.all(subCombPromises).then ->
# 					resolve result

getAllCombinations(getNormalizedLetterArray('ELAMRONMENT')).then (result)->
	console.log 'We have a result:!', result.length, result[Math.floor(result.length/2)]
