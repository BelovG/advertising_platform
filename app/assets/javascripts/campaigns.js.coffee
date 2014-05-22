$ ->
  if campaign_id = $('#campaign').attr('campaign_id')
    PrivatePub.subscribe "/messages/"+campaign_id, (data, channel) ->
      shows = data.message.shows
      clicks = data.message.clicks
      $('#shows').text(shows)
      $('#clicks').text(clicks)
      $('#conversion').text(((clicks/shows)*100).toFixed(2)+"%")

