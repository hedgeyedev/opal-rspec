/*
 * Test runner for phantomjs
 */
// var args = phantom.args;

var page = require('webpage').create();
var system = require('system');
var args = system.args.slice(1);
page.onConsoleMessage = function(msg) {
    console.log(msg);
};

page.onInitialized = function() {
    page.evaluate(function () {
        window.OPAL_SPEC_PHANTOM = true;
    });
};

/*
 * Exit phantom instance "safely" see - https://github.com/ariya/phantomjs/issues/12697
 * https://github.com/nobuoka/gulp-qunit/commit/d242aff9b79de7543d956e294b2ee36eda4bac6c
 */
function phantom_exit(code) {
  page.close();
  setTimeout(function () { phantom.exit(code); }, 0);
}

page.open(args[0], function(status) {
  if (status !== 'success') {
    console.error("Cannot load: " + args[0]);
    phantom_exit(1);
  } else {
    var timeout = parseInt(args[1] || 60000, 10);
    var start = Date.now();
    var interval = setInterval(function() {
      if (Date.now() > start + timeout) {
        console.error("Specs timed out");
        phantom_exit(124);
      } else {
        var code = page.evaluate(function() {
          return window.OPAL_SPEC_CODE;
        });

        if (code === 0 || code === 1) {
          clearInterval(interval);
          phantom_exit(code);
        }
      }
    }, 500);
  }
});

