$(function() {
    $.ajax({
        crossDomain : true,
        dataType: 'jsonp',
        jsonpCallback :  'callback' ,
        url: 'http://localhost:3000/campaigns/get_banner/',
        type: 'get',
        success: function(data) {
            $('#image').html('<a id="banner" onclick="counter_clicks();" data-id="'+ data.id +'" href="' + data.url + '"><img src="http://localhost:3000/' + data.image_url +'"></a>');
        }
    });
});

function counter_clicks() {
    var id = $('#banner').attr('data-id')
    $.ajax({
        crossDomain : true,
        dataType: 'jsonp',
        url: 'http://localhost:3000/campaigns/'+id+'/counter_clicks/',
        type: 'get',
        success: function(data) {
            console.log(data)
        }
    });
    window.location.href($(this).attr('href'));
}