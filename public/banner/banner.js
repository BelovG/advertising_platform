$(function() {
    if (sessionStorage.banners) {
        banner();
    } else {
        $.ajax({
            crossDomain : true,
            dataType: 'jsonp',
            jsonpCallback :  'callback' ,
            url: 'http://localhost:3000/campaigns/get_banner/',
            type: 'get',
            success: function(data) {
//                console.log(data);
                sessionStorage.banners = JSON.stringify(data);
                banner();
            }
        });
    }
});

function counter_clicks() {
    var id = $('#banner').attr('data-id');
    var url = $('#banner').attr('url');
    $.ajax({
        crossDomain : true,
        dataType: 'jsonp',
        url: 'http://localhost:3000/campaigns/'+id+'/counter_clicks/',
        type: 'get',
        success: function(data) {
            //console.log(data);
            document.location.href = url;
        }
    });
}

function counter_shows() {
    var id = $('#banner').attr('data-id');
    $.ajax({
        crossDomain : true,
        dataType: 'jsonp',
        url: 'http://localhost:3000/campaigns/'+id+'/counter_shows/',
        type: 'get',
        success: function(data) {
            //console.log(data);
        }
    });
}

function banner() {
    banners = JSON.parse(sessionStorage.banners);
    random_banner = banners[Math.floor(Math.random()*banners.length)];
    $('#image').html('<a id="banner" style = "cursor: pointer;" onclick="counter_clicks();" data-id="'+ random_banner.id +'" url="' + random_banner.url + '"><img src="http://localhost:3000/' + random_banner.image_url +'"></a>');
    counter_shows();
}