`import Ember from 'ember'`

ResumeCarouselComponent = Ember.Component.extend
  didInsertElement: ->
    Ember.$('.carousel-inner div.item').first().addClass('active')
    Ember.$('.carousel-inner li').first().addClass('active')

    Ember.$('.carousel-indicators li').each (index, li) ->
      Ember.$(li).attr('data-slide-to', index)

    Ember.$('.carousel').carousel('pause')
    return

  actions:
    previousSlide: ->
      Ember.$('.carousel').carousel('prev')

    nextSlide: ->
      Ember.$('.carousel').carousel('next')

`export default ResumeCarouselComponent`
