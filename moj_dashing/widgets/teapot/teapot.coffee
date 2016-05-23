class Dashing.Teapot extends Dashing.Widget

  onData: (data) ->
    $(@node).fadeOut().fadeIn()
    color = if @get('result') == 1 then "#96BF48" else "#BF4848"
    $(@get('node')).css('background-color', "#{color}")