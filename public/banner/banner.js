$(function() {
    if (sessionStorage.banners) {
        console.log("yes");
        banner();
    } else {
        $.ajax({
            crossDomain : true,
            dataType: 'jsonp',
            jsonpCallback :  'callback' ,
            url: 'http://localhost:3000/campaigns/get_banner/',
            type: 'get',
            success: function(data) {
                console.log("no");
                sessionStorage.banners = JSON.stringify(data);
                banner();
            }
        });
    }
});

function counter_clicks() {
    var id = $('#banner').attr('data-id')
    $.ajax({
        crossDomain : true,
        dataType: 'jsonp',
        url: 'http://localhost:3000/campaigns/'+id+'/counter_clicks/',
        type: 'get',
        success: function(data) {
            console.log(data);
        }
    });
    window.location.href($(this).attr('href'));
}

function counter_shows() {
    var id = $('#banner').attr('data-id');
    $.ajax({
        crossDomain : true,
        dataType: 'jsonp',
        url: 'http://localhost:3000/campaigns/'+id+'/counter_shows/',
        type: 'get',
        success: function(data) {
            console.log(data);
        }
    });
}

function banner() {
    banners = JSON.parse(sessionStorage.banners);
    random_banner = banners[Math.floor(Math.random()*banners.length)];
    console.log(random_banner.id);
    $('#image').html('<a id="banner" onclick="counter_clicks();" data-id="'+ random_banner.id +'" href="' + random_banner.url + '"><img src="http://localhost:3000/' + random_banner.image_url +'"></a>');
    counter_shows();
}