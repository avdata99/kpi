_ = require 'underscore'
Backbone = require 'backbone'
$configs = require './model.configs'
$baseView = require './view.pluggedIn.backboneView'
$viewTemplates = require './view.templates'

module.exports = do ->
  class ParamsView extends $baseView
    initialize: ({@rowView, @parameters={}, @paramsConfig})->
      $($.parseHTML $viewTemplates.row.paramsQuestionContent()).insertAfter @rowView.$('.card__header')
      @$el = @rowView.$('.params-view')
      console.log('paramsView init', @rowView)
      return

    render: ->
      for paramName, paramType of @paramsConfig
        new ParamOption(paramName, paramType, @parameters[paramName], @onParamChange.bind(@)).render().$el.appendTo(@$el)
      return @

    onParamChange: (paramName, paramValue) ->
      @parameters[paramName] = paramValue
      console.log('onParamChange', @parameters)
      @$el.trigger('params-update', @rowView.model.cid, @parameters)
      return

  class ParamOption extends $baseView
    className: 'param-option js-cancel-select-row'
    events: {
      'input input': 'onChange'
    }

    initialize: (@paramName, @paramType, @paramValue='', @onParamChange) -> return

    render: ->
      template = $($viewTemplates.$$render("ParamsView.#{@paramType}Param", @paramName, @paramValue))
      @$el.html(template)
      return @

    onChange: (evt) ->
      if @paramType is $configs.paramTypes.number
        val = evt.currentTarget.value
      else if @paramType is $configs.paramTypes.boolean
        val = evt.currentTarget.checked
      @onParamChange(@paramName, val)
      return

  ParamsView: ParamsView
