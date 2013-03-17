var fs = require('fs')

exports.range = function(start, end, step) {
  start = +start || 0;
  step = +step || 1;

  if (end == null) {
    end = start;
    start = 0;
  }
  // use `Array(length)` so V8 will avoid the slower "dictionary" mode
  // http://youtu.be/XAqIpGU8ZZk#t=17m25s
  var index = -1,
      length = Math.max(0, Math.ceil((end - start) / step)),
      result = Array(length);

  while (++index < length) {
    result[index] = start;
    start += step;
  }
  return result;
};

exports.writeStats = function(filename, stats) {
  fs.writeFileSync(filename, JSON.stringify(stats, null, 2) + '\n');
  console.log('  Saved to ' + filename);
};

// For debugging GitHub search.
var prop = function(name) {
  return function(item) {return item[name];};
};

var isNotIn = function(list) {
  return function(item) {return list.indexOf(item) === -1;};
};

var diff = function(prev, curr) {
  return prev.map(prop('login')).filter(isNotIn(curr.map(prop('login'))));
};

var reverseFind = function(list) {
  return function(login) {
    return list.filter(function(item) {
      return item.login === login;
    })[0];
  };
};

// diff(prev, curr).map(reverseFind(prev));
// prev.map(prop('login')).filter(isNotIn(logins))
