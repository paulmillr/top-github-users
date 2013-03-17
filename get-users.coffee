cheerio = require 'cheerio'
request = require 'superagent'
Batch = require 'batch'
fs = require 'fs'
utils = require './utils'

MIN_FOLLOWERS = 165
MAX_PAGES = 100
CONCURRENCY = 5

parseUsersStats = (html) ->
  $ = cheerio.load html
  [].slice.call($('.user-list-item > a'))
    .map((node) -> node.attribs.href)
    .map((href) -> href.replace /^\//, '')

getPageLogins = (url, callback) ->
  request.get url, (error, response) ->
    html = response.text
    console.log url
    unless error
      try
        logins = parseUsersStats html
      catch err
        error = err
    callback error, logins

getAllLogins = (urls, callback) ->
  batch = new Batch
  batch.concurrency CONCURRENCY
  urls.forEach (url) ->
    batch.push (done) ->
      getPageLogins url, done

  batch.end (error, allLogins) ->
    # Flatten the list once we’re finished.
    logins = [].concat.apply [], allLogins unless error
    callback error, logins

saveTopLogins = ->
  urls = utils.range(1, MAX_PAGES + 1).map (page) ->
    "https://github.com/search?q=followers%3A>#{MIN_FOLLOWERS}&p=#{page}&ref=searchbar&type=Users&s=followers"

  getAllLogins urls, (error, logins) ->
    throw error if error
    utils.writeStats './temp-logins.json', logins

saveTopLogins()
