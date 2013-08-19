#!/usr/bin/env coffee
fs = require 'fs'
utils = require './utils'

DISQUALIFIED = [
  'gugod' # 7K commits in 4 days.
]

saveTopLogins = ->
  MIN_FOLLOWERS = 188
  MAX_PAGES = 10
  urls = utils.range(1, MAX_PAGES + 1).map (page) ->
    "https://api.github.com/legacy/user/search/followers:%3E#{MIN_FOLLOWERS}?sort=followers&order=desc&start_page=#{page}"

  parse = (text) ->
    JSON.parse(text).users.map (_) -> _.username

  utils.batchGet urls, parse, (all) ->
    logins = [].concat.apply [], all
    filtered = logins.filter (name) ->
      name not in DISQUALIFIED
    utils.writeStats './temp-logins.json', filtered

saveTopLogins()
