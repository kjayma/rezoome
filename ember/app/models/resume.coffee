`import DS from 'ember-data'`

Resume = DS.Model.extend {
  md5sum: DS.attr('string')
  primaryEmail: DS.attr('string')
  filename: DS.attr('string')
  firstName: DS.attr('string')
  lastName: DS.attr('string')
  lastUpdate: DS.attr('date')
  address1: DS.attr('string')
  address2: DS.attr('string')
  city: DS.attr('string')
  state: DS.attr('string')
  zip: DS.attr('string')
  homePhone: DS.attr('string')
  mobilePhone: DS.attr('string')
  doctype: DS.attr('string')
  notes: DS.attr('string')
  resume_grid_fs_id: DS.attr('string')
  resume_text: DS.attr('string')
}

`export default Resume`
