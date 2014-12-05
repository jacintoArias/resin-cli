async = require('async')
_ = require('lodash')

token = require('../token/token')
server = require('../server/server')
errors = require('../errors/errors')
settings = require('../settings')

exports.authenticate = (credentials, callback) ->
	server.post settings.get('urls.authenticate'), credentials, (error, response) ->
		return callback(error, response?.body)

exports.login = (credentials, callback) ->
	async.waterfall([

		(callback) ->
			exports.authenticate(credentials, callback)

		(authToken, callback) ->
			token.saveToken(authToken, callback)

	], callback)

# Handy aliases
exports.isLoggedIn = token.hasToken
exports.getToken = token.getToken

# TODO: Maybe we should post to /logout or something
# like that to invalidate the token on the server?
exports.logout = token.clearToken

exports.parseCredentials = (credentials, callback) ->
	result = credentials.split(':')

	if result.length isnt 2
		error = new errors.InvalidCredentials()
		return callback?(error)

	callback? null,
		username: _.first(result)
		password: _.last(result)
