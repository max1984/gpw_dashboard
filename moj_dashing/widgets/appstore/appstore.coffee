class Dashing.Appstore extends Dashing.Widget
  ready: ->
    @onData(this)
 
  onData: (data) ->
    widget = $(@node)
    console.log(data)
    last_version = @get('last_version')
    all_versions = @get('all_versions')
    rating = last_version.average_rating
    console.log(rating)
    voters_count = last_version.voters_count
    console.log(voters_count)
    color = switch
        when rating <= 1 then "#FF0033"
        when rating <= 2 then "#FF99AD"
        when rating <= 3 or voters_count is "0" then "#FFFFD6"
        when rating <= 4 then "#CADFA4"
        when rating <= 5 then "#96BF48"
        else "#FFFFD6"
    
    $(@get('node')).css('background-color', "#{color}")
    widget.find('.appstore-rating-value').html( '<div>Last Version Average Rating</div><span id="appstore-rating-integer-value">' + rating + '</span>')
    widget.find('.appstore-voters-count').html( '<span id="appstore-voters-count-value">' + voters_count + '</span> Votes' )
    widget.find('.appstore-all-versions-average-rating').html( all_versions.average_rating )
    widget.find('.appstore-all-versions-voters-count').html( all_versions.voters_count )
