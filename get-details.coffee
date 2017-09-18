#!/usr/bin/env coffee
cheerio = require 'cheerio'
utils = require './utils'

stats = {}

getStats = (html, url) ->
  $ = cheerio.load html
  byProp = (field) -> $("[itemprop='#{field}']")
  getInt = (text) -> parseInt text.replace ',', ''
  getOrgName = (item) -> $(item).attr('aria-label')
  login = byProp('additionalName').text().trim()
  getFollowers = ->
    text = $("a[href=\"/#{login}?tab=followers\"] > .Counter").text().trim()
    multiplier = if text.indexOf('k') > 0 then 1000 else 1
    (parseFloat text) * multiplier

  pageDesc = $('meta[name="description"]').attr('content')

  userStats =
    name: byProp('name').text().trim()
    login: login
    location: byProp('homeLocation').text().trim()
    language: (/\sin ([\w-+#\s\(\)]+)/.exec(pageDesc)?[1] ? '')
    gravatar: byProp('image').attr('href')
    followers: getFollowers()
    organizations: $('h2:contains("Organizations") ~ a').toArray().map(getOrgName)
    contributions: getInt $('div.js-contribution-graph > h2').text().trim().split(' ')[0]

  stats[userStats.login] = userStats
  userStats

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
  utils.batchGet urls, getStats, ->
    utils.writeStats './raw/github-users-stats.json', sortStats stats

saveStats()
