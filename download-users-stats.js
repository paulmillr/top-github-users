var utils = require('./utils')

var MAX_PAGES = 99;
var stats = {};

var parseField = function(regex, html) {
  var m = html.match(regex) || [];
  return m[1] || '';
};

var parseNum = function(string) {
  return parseInt(string.replace(/,/g, '')) || 0;
};

var getSearchUrls = function(max, query) {
  var urls = [];
  for (var i = 0; i < max; i++) {
    urls[i] = 'https://github.com/search?q=' + query + '&p='
        + (i + 1) + '&ref=searchbar&type=Users'
  }
  return urls;
};

var parseUserStats = function(username, partial) {
  return {
    username: username,
    aka: parseField(/<span class="aka"> - (.*)?<\/span>/, partial),
    gravatar: parseField(/<img height="30" src="(.*?)"/, partial),
    followers: parseNum(parseField(/([\d,]*) followers/, partial)),
    repositories: parseNum(parseField(/([\d,]*) repositories/, partial)),
    location: parseField(/located in (.*?)\s*<\/div>/, partial) || 'Unknown',
    language: parseField(/repositories([\s\S]+)located/, partial)
        .replace(/<\/?span>/g, '').replace(/[\s|]/g, '').trim()
  }
};

var parseUsersStats = function(html) {
  var match = html.match(/<div class="results">([\s\S]+?)<\/div>\s*<div class="pagination">/)
  if (!match || !match[1]) return;

  match[1].split('class="result"').forEach(function(partial) {
    var username = parseField(/<a href="\/.+?">(.+?)<\/a>/, partial)
    if (username) {
      stats[username] = parseUserStats(username, partial);
    }
  });
};

var searchUrls = getSearchUrls(MAX_PAGES, 'followers%3A%3E0');
utils.getPages(searchUrls, parseUsersStats, function() {
  utils.writeStats('./temp-github-users-no-contribs.json', stats);
});
