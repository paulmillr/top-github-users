utils = require './utils'
fs = require 'fs'
data = require './raw/github-users-stats'
prev = require './old-logins'
curr = require './temp-logins'

filtered = prev
  .filter(utils.isNotIn(curr))
  .map(utils.reverseFind(data))
  .map (_) ->
    login: _.login, followers: _.followers
  .sort (a, b) ->
    b.followers - a.followers

console.log filtered
console.log JSON.stringify filtered.map(utils.prop 'login'), null, 2
