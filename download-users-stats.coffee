cheerio = require 'cheerio'
utils = require './utils'


stats = {}

getStats = (html, url) ->
  $ = cheerio.load html
  byProp = (field) -> $("[itemprop='#{field}']")
  getInt = (text) -> parseInt text.replace ',', ''
  getOrgName = (index, item) -> $(item).attr('title')
  getFollowers = ->
    parseInt $('.stats li:nth-child(1) a').text().replace 'k', '000'

  pageDesc = $('meta[name="description"]').attr('content')

  userStats =
    name: byProp('name').text().trim()
    login: byProp('additionalName').text().trim()
    location: byProp('homeLocation').text().trim()
    language: (/in (\w+)/.exec(pageDesc)?[1] ? '')
    gravatar: byProp('image').attr('href')
    followers: getFollowers()
    organizations: $('.orgs li > a').map(getOrgName)
    contributions: getInt $('.contrib-day > .num').text()
    contributionsStreak: getInt $('.contrib-streak > .num').text()
    contributionsCurrentStreak: getInt $('.contrib-streak-current > .num').text()

  stats[userStats.login] = userStats

sortStats = (stats) ->
  minContributions = 1
  Object.keys(stats)
    .filter (login) ->
      stats[login].contributions >= minContributions
    .sort (a, b) ->
      stats[b].contributions - stats[a].contributions
    .map (login) ->
      stats[login]

saveStats = ->
  logins = require './temp-logins.json'
  urls = logins.map (login) -> "https://github.com/#{login}"
  utils.getPages urls, getStats, ->
    utils.writeStats './raw/github-users-stats.json', sortStats stats

saveStats()
