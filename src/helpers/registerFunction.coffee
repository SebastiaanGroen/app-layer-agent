debug = (require "debug") "app:helpers:registerFunction"
config = require "config"

module.exports = ({ taskManager, name, fn, sync = false }) ->
	name = [
		config.mqtt.actions.baseTopic
		config.mqtt.clientId
		name
	].join "/"

	# remove duplicate forward slashes
	name = name.replace /\/{2,}/g, "/"

	debug "Registering function '#{name}' ..."

	taskManager.register name, (...params) ->
		debug "Executing function '#{name}' ..."

		# sync actions are currently unqueueable because
		# the server expects a response, which is not possible
		# due to the background processing of actions
		if sync
			fn ...params
		else
			taskManager.addTask
				name:   name
				fn:     fn
				params: params

			status: "ACK"
