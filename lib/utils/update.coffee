###
Copyright 2016-2017 Resin.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###

updateNotifier = require('update-notifier')
isRoot = require('is-root')
packageJSON = require('../../package.json')

# Check for an update once a day. 1 day granularity should be
# enough, rather than every run.
resinUpdateInterval = 1000 * 60 * 60 * 24 * 1

# `update-notifier` creates files to make the next
# running time ask for updated, however this can lead
# to ugly EPERM issues if those files are created as root.
if not isRoot()
	notifier = updateNotifier
		pkg: packageJSON
		updateCheckInterval: resinUpdateInterval

exports.hasAvailableUpdate = ->
	return notifier?

exports.notify = ->
	return if not exports.hasAvailableUpdate()
	notifier.notify(defer: false)
	if notifier.update?
		console.log('Notice that you might need administrator privileges depending on your setup\n')
