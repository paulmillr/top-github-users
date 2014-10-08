#!/usr/bin/env coffee
cheerio = require 'cheerio'
utils = require './utils'

stats = {}

getStats = (html, url) ->
  $ = cheerio.load html
  byProp = (field) -> $("[itemprop='#{field}']")
  getInt = (text) -> parseInt text.replace ',', ''
  getOrgName = (item) -> $(item).attr('aria-label')
  getFollowers = ->
    text = $('.vcard-stats > a:nth-child(1) > .vcard-stat-count').text().trim()
    multiplier = if text.indexOf('k') > 0 then 1000 else 1
    (parseFloat text) * multiplier

  pageDesc = $('meta[name="description"]').attr('content')

  userStats =
    name: byProp('name').text().trim()
    login: byProp('additionalName').text().trim()
    location: byProp('homeLocation').text().trim()
    language: (/\sin ([\w-]+)/.exec(pageDesc)?[1] ? '')
    gravatar: byProp('image').attr('href')
    followers: getFollowers()
    contributions: getInt $('.contrib-day > .num').text()
    contributionsStreak: getInt $('.contrib-streak > .num').text()
    contributionsCurrentStreak: getInt $('.contrib-streak-current > .num').text()
    organizations: $('#site-container > div > div > div.column.one-fourth.vcard > div.clearfix > a').toArray().map(getOrgName)

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
