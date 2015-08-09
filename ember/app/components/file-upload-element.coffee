`import Ember from 'ember'`
`import EmberUploader from 'ember-uploader'`

FileUploadElement = EmberUploader.FileField.extend
  classNames: ['file-uploader']
  url: ''
  filesDidChange: (files) ->
    console.log('got here')

    if files && files[0]
      console.log('more progress')
      reader = new FileReader()

      reader.onload = (e) =>
        console.log('in reader')
        fileToUpload = reader.result
        @get('model').set('content', fileToUpload)

      reader.readAsDataURL(files[0])

`export default FileUploadElement`
