import Ember from 'ember';
import EmberUploader from 'ember-uploader';

export default EmberUploader.FileField.extend({
  classNames: ['file-uploader'],
  url: '',
  filesDidChange: function(files) {
    var uploadUrl = this.get('url');
    var promise = null;
    var self= this;

    this.sendAction('uploadStarted', files[0].name)

    var uploader = EmberUploader.Uploader.create({
      url: uploadUrl
    });

    if (!Ember.isEmpty(files)) {
      promise = uploader.upload(files[0]);
    }

    promise.then(function(data) {
      // Handle success
      self.sendAction('uploadSucceeded');
    },
    function(error) {
      console.log('error on upload resume');
      self.sendAction('uploadFailed');
    });
  }
});
