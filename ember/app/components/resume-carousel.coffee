`import Ember from 'ember'`

ResumeCarouselComponent = Ember.Component.extend

  didInsertElement: ->
    this.updateActives

    Ember.$('.carousel-indicators li').each (index, li) ->
      Ember.$(li).attr('data-slide-to', index)

    return

  actions:
    previousSlide: ->
      Ember.$('.carousel').carousel('prev')
      Ember.$('.carousel').carousel('pause')

    nextSlide: ->
      Ember.$('.carousel').carousel('next')
      Ember.$('.carousel').carousel('pause')

    destroyOtherResume: (otherResume) ->
      @sendAction('destroyOtherResume', otherResume)


  resumeObserver: ( ->
    Ember.run.scheduleOnce('afterRender', this, this.updateActives)
  ).observes('other_resumes', 'resumes_on_file')

  updateActives: ->
    Ember.$('.carousel-inner div.item').removeClass('active')
    Ember.$('.carousel-inner div.item').first().addClass('active')
    Ember.$('.carousel-inner li').removeClass('active')
    Ember.$('.carousel-inner li').first().addClass('active')
    Ember.$('.carousel-indicators li').removeClass('active')
    Ember.$('.carousel-indicators li').first().addClass('active')
    @highlightSearchTerms()
    Ember.$('.carousel').carousel('pause')

  highlightSearchTerms: ->
    search_terms = @get('search_terms')
    if search_terms
      pre = Ember.$('pre')
      search_terms.split("\n").forEach (term) ->
        highlighted_term = '<span class="highlight">'+term+'</span>'
        regEx = new RegExp(term, "ig")
        pre.html(pre.html().replace(regEx, highlighted_term))

`export default ResumeCarouselComponent`
