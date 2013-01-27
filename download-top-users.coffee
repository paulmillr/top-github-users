cheerio = require 'cheerio'
utils = require './utils'

saveTopLogins = ->
  MAX_PAGES = 99
  users = []

  parseUsersStats = (html) ->
    $ = cheerio.load html
    $('.members-list > li > a')
      .map((index, node) -> node.attribs.href)
      .map((href) -> href.replace /^\//, '')
      .forEach (nick) -> users.push nick
    return

  searchUrls = utils.range(1, MAX_PAGES + 1).map (page) ->
    "https://github.com/search?q=followers%3A%3E0&p=#{page}&ref=searchbar&type=Users"

  utils.getPages searchUrls, parseUsersStats, ->
    utils.writeStats './temp-logins.json', users

saveTopLogins()
