import resolver from './helpers/resolver';
import flashMessageHelper from './helpers/flash-message';

import { setResolver } from 'ember-mocha';

setResolver(resolver);
document.write('<div id="ember-testing-container"><div id="ember-testing"></div></div>');

$(document).ready(function(){
  // Declare `expect` as a global here instead of as a var in individual tests.
  // This avoids jshint warnings re: `Redefinition of 'expect'`.
  window.expect = chai.expect;
});
