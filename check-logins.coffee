#!/usr/bin/env coffee
utils = require './utils'
fs = require 'fs'
data = require './raw/github-users-stats.json'
prev = require './old-logins.json'
curr = require './temp-logins.json'

filtered = prev
  .filter(utils.isNotIn(curr))
  .map(utils.reverseFind(data))
  .filter((_) -> _)
  .map (_) ->
    login: _.login, followers: _.followers
  .sort (a, b) ->
    b.followers - a.followers

console.log filtered
console.log JSON.stringify filtered.map(utils.prop 'login'), null, 2
