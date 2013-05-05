var fs = require('fs');
var Batch = require('batch');
var request = require('superagent');

var batchGet = exports.batchGet = function(urls, progressback, callback) {
  var batch = new Batch;
  batch.concurrency(5);
  urls.forEach(function(url) {
    batch.push(function(done) {
      request
        .get(url)
        .set('User-Agent', 'curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5')
        .end(function(error, response) {
          console.log(url);
          if (error) throw new Error(error);
          if (response.error) {
            if (response.status === 404) {
              done();
            } else {
              throw response.error;
            }
          }
          var result;
          try {
            result = progressback(response.text);
          } catch (err) {
            error = err;
          }
          done(error, result);
        });
    });
  });

  batch.end(function(error, all) {
    if (error) throw new Error(error);
    callback(all);
  });
};

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

exports.prop = prop;
exports.isNotIn = isNotIn;
exports.diff = diff;
exports.reverseFind = reverseFind;

// diff(prev, curr).map(reverseFind(prev));
// prev.map(prop('login')).filter(isNotIn(logins))
