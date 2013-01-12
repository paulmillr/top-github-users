var util = require('./util');

var sort = function(obj, total) {
  var swap = {};

  Object.keys(obj).forEach(function(key, value) {
    value = obj[key];
    swap[value] = swap[value] || [];
    swap[value].push(key);
  })

  var ret = {};
  for (var i = total; i >= 0; i--) {
    var k = swap[i];
    if (k) {
      k.forEach(function(lang) {
        ret[lang] = i;
      });
    }
  }

  return ret
};

var getLanguageStats = function(inputfile, outputfile) {
  var stats = require(inputfile);
  var total = stats.length;
  var languages = {Total: total};

  stats.forEach(function(stat) {
    var lang = stat.language;
    if (!lang) return;
    if (!languages[lang]) languages[lang] = 0
    languages[lang] += 1;
  });

  languages = (sort(languages, total));
  util.saveStats(outputfile, languages);
};

getLanguageStats('./github-users-sorted-stats.json', 'github-languages-stats.json');
