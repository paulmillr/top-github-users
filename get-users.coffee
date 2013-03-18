cheerio = require 'cheerio'
request = require 'superagent'
Batch = require 'batch'
fs = require 'fs'
utils = require './utils'

saveTopLogins = ->
  MIN_FOLLOWERS = 165
  MAX_PAGES = 10
  urls = utils.range(1, MAX_PAGES + 1).map (page) ->
    "https://api.github.com/legacy/user/search/followers:%3E#{MIN_FOLLOWERS}?sort=followers&order=desc&start_page=#{page}"

  parse = (text) -> JSON.parse(text).users.map (_) -> _.username

  utils.batchGet urls, parse, (all) ->
    logins = [].concat.apply [], all
    utils.writeStats './temp-logins.json', logins

saveTopLogins()
