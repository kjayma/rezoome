`import GoogleMapMarkerView from '../google-map/marker'`

RezoomeMarkerView = GoogleMapMarkerView.extend
  googleEvents:
    click: 'switchResume'

`export default RezoomeMarkerView`
