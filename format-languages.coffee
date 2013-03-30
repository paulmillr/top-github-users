#!/usr/bin/env coffee
utils = require './utils'

getLanguageStats = (inputFile, outFile) ->
  stats = require inputFile
  total = stats.length
  unsorted = Total: total
  stats.forEach (stat) ->
    {language} = stat
    return unless language
    unsorted[language] ?= 0
    unsorted[language] += 1

  languages = {}
  Object.keys(unsorted)
    .sort (a, b) ->
      unsorted[b] - unsorted[a]
    .forEach (language) ->
      languages[language] = unsorted[language]

  utils.writeStats outFile, languages

getLanguageStats './raw/github-users-stats.json', './raw/github-languages-stats.json'
