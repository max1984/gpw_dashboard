
class Dashing.ServerStatusSquares extends Dashing.Widget

    onData: (data) ->
        $(@node)
        if data.result != null
	        switch data.result
	            when 1 then color = "#96BF48" 
	            when 0 then color = "#FF0033" 
	            when 2 then color = "orange" 
	            when 4 then color = "#60DEE5"
	        $(@get('node')).css('background-color', "#{color}")