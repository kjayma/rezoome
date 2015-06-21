`import DS from 'ember-data'`

DS.RESTSerializer.extend DS.EmbeddedInModelMixin,
  attrs:
    otherResumes: embedded: 'always'

`export default DS.RESTSerializer`
