/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'rezoome',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },
    contentSecurityPolicy: {
      'default-src': "http://kevin-u46e2:3000",
      'script-src': "'self' 'unsafe-inline' 'unsafe-eval' http://kevin-u46e2:35729",
      'font-src': "'self'",
      'connect-src': "'self' ws://kevin-u46e2:35729 http://kevin-u46e2:3000",
      'img-src': "'self'",
      'style-src': "'self' 'unsafe-inline'",
      'frame-src': "'self' http://kevin-u46e2:3000"
    },
    flashMessageDefaults: {
      timeout            : 15000
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }

  return ENV;
};
