export default StringUtils =
	removeAccents: (source)->
		result = source
		result = result.replace /[èéêëẽēĕėęěȅȇ]/ig, 'e'
		result = result.replace /[àáâäãåǟǡǻȁȃȧąăā]/ig, 'a'
		result = result.replace /[ìíîïĩīĭį]/ig, 'i'
		result = result.replace /[ùúûüũūŭůűųȕȗǔǖǘǚǜ]/ig, 'u'
		result = result.replace /[òóôöõōŏőǒȫȭȯȱ]/ig, 'o'
		result = result.replace /[ÿŷỳ]/ig, 'y'
		result = result.replace /[ñǹńň]/ig, 'n'
		result = result.replace /[çčćĉċ]/ig, 'c'
		result = result.replace /[æǣǽ]/ig, 'ae'
		result = result.replace /[œ]/ig, 'oe'
		result

	normalize: (source)->
		result = source
		result = result.trim().normalize()
		result = result.toLowerCase()
		result = StringUtils.removeAccents result
		# Make sure to keep only letters
		result = result.replace /[^a-z]+/ig, ''
		result
