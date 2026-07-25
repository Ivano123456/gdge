var music_time
var currentSongInformations = {}
var musicid = 1
var myname = '0RESMON'
var driver = false
currentSongInformations.name = null
currentSongInformations.url = null

var mode = 'normal'


$(document).ready(function() {
    dragElement(document.getElementById("mainscreen"));
    dragElement(document.getElementById("vehicle-container"));
    function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById(elmnt.id + "header")) {
            document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
        } else {
            elmnt.onmousedown = dragMouseDown;
        }
    
        function dragMouseDown(e) {
            e = e || window.event;
            e.preventDefault();
            pos3 = e.clientX;
            pos4 = e.clientY;
            document.onmouseup = closeDragElement;
            document.onmousemove = elementDrag;
        }
    
        function elementDrag(e) {
                e = e || window.event;
                e.preventDefault();
                pos1 = pos3 - e.clientX;
                pos2 = pos4 - e.clientY;
                pos3 = e.clientX;
                pos4 = e.clientY;
        
                
                elmnt.style.top = (elmnt.offsetTop - pos2) / window.innerHeight * 100 + "vh";
                elmnt.style.left = (elmnt.offsetLeft - pos1) / window.innerWidth * 100 + "vw";
        }
    
        function closeDragElement() {
            document.onmouseup = null;
            document.onmousemove = null;
        }
        
        const slider = elmnt.querySelector('.custom-range2');
        const slider2 = elmnt.querySelector('.custom-range');
        const slider3 = elmnt.querySelector('.form__input');
        if (slider) {
            slider.onmousedown = function(e) {
                e.stopPropagation();
            };
        }
        if (slider2) {
            slider2.onmousedown = function(e) {
                e.stopPropagation();
            };
        }
        if (slider3) {
            slider3.onmousedown = function(e) {
                e.stopPropagation();
            };
        }
    }
    const rangeSlider = document.getElementById('colorRange');
    rangeSlider.style.setProperty('--color1', '#FFFFFF');
    const slider = document.getElementById('colorRange');
    slider.addEventListener('input', function() {
        if (!driver) { return; }
        const value = (slider.value - slider.min) / (slider.max - slider.min) * 100;
        slider.style.setProperty('--value', value + '%');
    });
    slider.dispatchEvent(new Event('input'));

    const rangeSlider2 = document.getElementById('colorRange2');
    rangeSlider2.style.setProperty('--color1', '#FFFFFF');
    const slider2 = document.getElementById('colorRange2');
    slider2.addEventListener('input', function() {
        if (!driver) { return; }
        
        const rawValue = (slider2.value - slider2.min) / (slider2.max - slider2.min);
        
        const clampedValue = Math.min(Math.max(rawValue, 0.1), 1.0);
        
        slider2.style.setProperty('--value', clampedValue * 100 + '%');
        
        var resimElementi = $("#pause");
        resimElementi.attr('src', 'img/pause.svg');
        $('.middle-cont').css('background-image', 'url(img/middlegreen.png)')    

        $.post("https://0r-carcontrol/MusicAction", JSON.stringify({
            type: 'volume',
            payload: clampedValue
        }));
    });
    slider2.dispatchEvent(new Event('input'));
    

    var carmenu = false
    var vehicle = false
    var spotify = false
    document.querySelectorAll('.button').forEach(button => {
        button.addEventListener('click', function() {
            if (!driver) { return; }
            if (this.id == 'carmenu') {
                if (!carmenu) {
                    carmenu = true;
                    spotify = false;
                    FadeIn('.top-main-screen2', 400);
                    FadeIn('.top-main-screen', 400);
                    FadeOut('.spotify', 400);
                } else {
                    carmenu = false;
                    spotify = false;
                    FadeOut('.spotify', 400);
                    FadeOut('.top-main-screen2', 400);
                    FadeOut('.top-main-screen', 400);
                }
            } else if (this.id == 'spotify') {
                if (!spotify) {
                    carmenu = false;
                    spotify = true;
                    FadeOut('.top-main-screen2', 400);
                    FadeOut('.top-main-screen', 400);
                    FadeIn('.spotify', 400);
                } else {
                    carmenu = false;
                    spotify = false;
                    FadeOut('.top-main-screen2', 400);
                    FadeOut('.top-main-screen', 400);
                    FadeOut('.spotify', 400);
                }
            } else if (this.id == 'vehicle') {
                if (!vehicle) {
                    vehicle = true;
                    FadeIn('.vehicle-container', 400);
                } else {
                    vehicle = false;
                    FadeOut('.vehicle-container', 400);
                }
            }
        });
    });

    $(document).on('click', '#normal', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        mode = 'normal'
        var resimElementi = $("#top-bg"); 

       
        resimElementi.addClass('fade-out');

        
        resimElementi.fadeOut(500, function() {
            
            resimElementi.attr('src', 'img/mavibg.png');
            
            resimElementi.fadeIn(500);
            $('.mainscreen .top-main-screen .header-cont .header-name .text1').css('color', '#276EF8')
            $('.mainscreen .top-main-screen2 .fuel').css('background', '#276EF8')
            $('.mainscreen .top-main-screen2 .miles').css('background', '#276EF8')
        });
        var resimElementi2 = $("#header"); 

       
        resimElementi2.addClass('fade-out');

        
        resimElementi2.fadeOut(500, function() {
            
            resimElementi2.attr('src', 'img/blue-header-bg.png');
            
            resimElementi2.fadeIn(500);
        });

        resimElementi2.addClass('fade-out');

        var resimElementi3 = $("#hava"); 
        
        resimElementi3.fadeOut(500, function() {
            
            resimElementi3.attr('src', 'img/hava.png');
            
            resimElementi3.fadeIn(500);
        });
    });


    $(document).on('click', '#drift', function(e) {
        if (!driver) { return; }
        e.preventDefault();
        mode = 'drift'
        var resimElementi = $("#top-bg"); 

       
        resimElementi.addClass('fade-out');

        
        resimElementi.fadeOut(500, function() {
            
            resimElementi.attr('src', 'img/turuncubg.png');
            
            resimElementi.fadeIn(500);
            $('.mainscreen .top-main-screen .header-cont .header-name .text1').css('color', '#f86227')
            $('.mainscreen .top-main-screen2 .fuel').css('background', '#f86227')
            $('.mainscreen .top-main-screen2 .miles').css('background', '#f86227')
        });
        var resimElementi2 = $("#header"); 

       
        resimElementi2.addClass('fade-out');

        
        resimElementi2.fadeOut(500, function() {
            
            resimElementi2.attr('src', 'img/turuncu-header-bg.png');
            
            resimElementi2.fadeIn(500);
        });
        var resimElementi3 = $("#hava"); 
        
        resimElementi3.fadeOut(500, function() {
            
            resimElementi3.attr('src', 'img/turuncuhava.png');
            
            resimElementi3.fadeIn(500);
        });
    });


    $(document).on('click', '#sport', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        mode = 'sport'
        var resimElementi = $("#top-bg"); 

       
        resimElementi.addClass('fade-out');

        
        resimElementi.fadeOut(500, function() {
            
            resimElementi.attr('src', 'img/kirmizibg.png');
            
            resimElementi.fadeIn(500);
            $('.mainscreen .top-main-screen .header-cont .header-name .text1').css('color', '#f82727')
            $('.mainscreen .top-main-screen2 .fuel').css('background', '#f82727')
            $('.mainscreen .top-main-screen2 .miles').css('background', '#f82727')
        });


        var resimElementi2 = $("#header"); 

       
        resimElementi2.addClass('fade-out');

        
        resimElementi2.fadeOut(500, function() {
            
            resimElementi2.attr('src', 'img/kirmizi-header-bg.png');
            
            resimElementi2.fadeIn(500);
        });
        var resimElementi3 = $("#hava"); 
        
        resimElementi3.fadeOut(500, function() {
            
            resimElementi3.attr('src', 'img/kirmizihava.png');
            
            resimElementi3.fadeIn(500);
        });
    });

    var hood = false
    $(document).on('click', '.hood', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!hood) {
            hood = true
            $('.hood').css('background-image', 'url(img/selected.png)')
            FadeIn('.hoodselect', 350)
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 4
            }));
        } else {
            hood = false
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 4
            }));
            FadeOut('.hoodselect', 350)
            $('.hood').css('background-image', 'url(img/select.png)')
        }
    });
    var r_d_f = false
    $(document).on('click', '.right-d-f', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!r_d_f) {
            r_d_f = true
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 1
            }));
            FadeIn('.right-d-f-select', 350)
            $('.right-d-f').css('background-image', 'url(img/selected.png)')
        } else {
            r_d_f = false
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 1
            }));
            FadeOut('.right-d-f-select', 350)
            $('.right-d-f').css('background-image', 'url(img/select.png)')
        }
    });
    var r_d_b = false
    $(document).on('click', '.right-d-b', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!r_d_b) {
            r_d_b = true
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 3
            }));
            FadeIn('.right-d-b-select', 350)
            $('.right-d-b').css('background-image', 'url(img/selected.png)')
        } else {
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 3
            }));
            r_d_b = false
            FadeOut('.right-d-b-select', 350)
            $('.right-d-b').css('background-image', 'url(img/select.png)')
        }
    });
    var l_d_b = false
    $(document).on('click', '.left-d-b', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!l_d_b) {
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 2
            }));
            l_d_b = true
            FadeIn('.left-d-b-select', 350)
            $('.left-d-b').css('background-image', 'url(img/selected.png)')
        } else {
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 2
            }));
            l_d_b = false
            FadeOut('.left-d-b-select', 350)
            $('.left-d-b').css('background-image', 'url(img/select.png)')
        }
    });
    var l_d_f = false
    $(document).on('click', '.left-d-f', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!l_d_f) {
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 0
            }));
            l_d_f = true
            $('.left-d-f').css('background-image', 'url(img/selected.png)')
            FadeIn('.left-d-f-select', 350)
        } else {
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 0
            }));
            l_d_f = false
            $('.left-d-f').css('background-image', 'url(img/select.png)')
            FadeOut('.left-d-f-select', 350)
        }
    });
    var trunk= false
    $(document).on('click', '.trunk', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!trunk) {
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 5
            }));
            trunk = true
            FadeIn('.trunkselect', 350)
            $('.trunk').css('background-image', 'url(img/selected.png)')
        } else {
            $.post("https://0r-carcontrol/opendoor", JSON.stringify({
                door: 5
            }));
            trunk = false
            FadeOut('.trunkselect', 350)
            $('.trunk').css('background-image', 'url(img/select.png)')
        }
    });
    var windows= false
    $(document).on('click', '.windows', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!windows) {
            windows = true
            $.post("https://0r-carcontrol/openw");
            FadeIn('.window1', 350)
            FadeIn('.window2', 350)
            $('.windows').css('background-image', 'url(img/windows.png)')
        } else {
            $.post("https://0r-carcontrol/closew");
            FadeOut('.window1', 350)
            FadeOut('.window2', 350)
            windows = false
            $('.windows').css('background-image', 'url(img/select.png)')
        }
    });
    
    
    var resume= false
    $(document).on('click', '#pause', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (!resume) {
            resume = true
            var resimElementi = $("#pause");
            resimElementi.attr('src', 'img/pause.svg');
            $('.middle-cont').css('background-image', 'url(img/middlegreen.png)')    
            $.post("https://0r-carcontrol/ResumeMusic");
        } else {
            resume = false
            var resimElementi = $("#pause");
            resimElementi.attr('src', 'img/resume.png');
            $('.middle-cont').css('background-image', 'url(img/middle.png)')    
            $('.windows').css('background-image', 'url(img/select.png)')

            $.post("https://0r-carcontrol/PauseMusic");
        }
    });

    $(document).on('click', '#close', function(e) {
        e.preventDefault()
        FadeOut('.mainscreen', 350)
        if (vehicle) {
            $.post("https://0r-carcontrol/close2");
        } else {
            
            $.post("https://0r-carcontrol/close");
        }
    });
    var cevir = false
    $(document).on('click', '#cevir', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        if (cevir) {
            cevir = false
            $('.vehicle-container').css('transform', 'rotate(0deg)')
        } else {
            cevir = true
            $('.vehicle-container').css('transform', 'rotate(-90deg)')
        }
    });

    
    $(document).on('click', '#seat', function(e) {
        e.preventDefault()
        var seat =  $(e.currentTarget).attr("data-id");
        $.post("https://0r-carcontrol/seat", JSON.stringify({
            door: Number(seat)
        }));
    });
    
    $(document).on('click', '#drift', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/driftmode");
    });
    
    $(document).on('click', '#normal', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/normalmode");
    });
    
    $(document).on('click', '#sport', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/sportmode");
    });
    
    $(document).on('click', '#toggleengine', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/toggleengine");
    });
    
    $(document).on('click', '#hazard', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/hazard");
    });
    
    $(document).on('click', '#isik', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/light");
    });
    $(document).on('click', '#int', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/interior");
    });
    $(document).on('click', '#openneon', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/openneon");
    });
    $(document).on('click', '#mode1', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/neon", JSON.stringify({
            mode: "neon2"
        }));
    });
    $(document).on('click', '#mode2', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        $.post("https://0r-carcontrol/neon", JSON.stringify({
            mode: "random"
        }));
    });
    $(document).on('click', '.submit', function(e) {
        e.preventDefault()
        if (!driver) { return; }
        const url = document.getElementById("music").value;

        if (url != '') {
            if (url.startsWith("http")) {
                $.getJSON('https://noembed.com/embed?url=', { format: 'json', url: url }, (data) => {
                    $.post("https://0r-carcontrol/addtoplaylist", JSON.stringify({
                        url: url,
                        name: data.title
                    }));
                });
            }
        }
    });
    $(document).on('click', '#spotify1', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        $('.textler .header2').html(myname+'’s Playlist')
        $.post("https://0r-carcontrol/GetMyPlaylist", JSON.stringify({
            mode: "random"
        }), function(cb) {
            UpdateMyPlaylist(cb[0], cb[1])
        });
    });
    $(document).on('click', '#spotify2', function(e) {
        if (!driver) { return; }
        $('.textler .header2').html('All Playlist')
        e.preventDefault()
        $.post("https://0r-carcontrol/GetAllPlaylist", JSON.stringify({
            mode: "random"
        }), function(cb) {
            UpdateMyPlaylist(cb[0], cb[1])
        });
    });
    $(document).on('click', '.submit2', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        const url =  $(e.currentTarget).attr("data-url");

        if (url != '') {
            if (url.startsWith("http")) {
                $.getJSON('https://noembed.com/embed?url=', { format: 'json', url: url }, (data) => {
                    $.post("https://0r-carcontrol/addtoplaylist", JSON.stringify({
                        url: url,
                        name: data.title
                    }));
                });
            }
        }
    });
    $(document).on('click', '#trash', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        const id =  $(e.currentTarget).attr("data-sqlid");
        const url =  $(e.currentTarget).attr("data-url");
        $.post("https://0r-carcontrol/DeleteMusic", JSON.stringify({
            sqlid: Number(id),
            url:url
        }));
    });
    $(document).on('click', '#song', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        const url =  $(e.currentTarget).attr("data-url");
        const name =  $(e.currentTarget).attr("data-name");
        musicid =  $(e.currentTarget).attr("data-id");

        currentSongInformations.name = name
        currentSongInformations.url = url
        var resimElementi = $("#pause");
        resimElementi.attr('src', 'img/pause.svg');
        $('.middle-cont').css('background-image', 'url(img/middlegreen.png)')    
        $.post("https://0r-carcontrol/ResumeMusic");
        $('.music-name .name1').html(name)
        $.post("https://0r-carcontrol/MusicAction", JSON.stringify({
            type: 'play',
            url: url,
            name: name,
            id: musicid
        }));
        const colorRange = document.getElementById("colorRange2");
        colorRange.style.setProperty('--value', 0.5 * 100 + '%');
        
        resume = true
        var resimElementi = $("#pause");
        resimElementi.attr('src', 'img/pause.svg');
        $('.middle-cont').css('background-image', 'url(img/middlegreen.png)')    
    });

    document.getElementById("colorRange").addEventListener("input", function() {
        if (!driver) { return; }
        const rangeValue = this.value;
        
        if (currentSongInformations.name && music_time.maxDuration > 0) {
            const pos = parseFloat(rangeValue); 
            const newTime = pos * music_time.maxDuration / 100; 
            
            
            const timestamp = Math.min(newTime, music_time.maxDuration);
            var resimElementi = $("#pause");
            resimElementi.attr('src', 'img/pause.svg');
            $('.middle-cont').css('background-image', 'url(img/middlegreen.png)')    
            $.post("https://0r-carcontrol/ResumeMusic");
            $.post("https://0r-carcontrol/MusicAction", JSON.stringify({
                type: 'timestamp',
                payload: timestamp
            }));
        }
    });

    $(document).on('click', '#sol', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        $.post("https://0r-carcontrol/ChangeMusic", JSON.stringify({
            icon: true,
            type: 'sol'
        }));
    });

    $(document).on('click', '#sag', function(e) {
        if (!driver) { return; }
        e.preventDefault()
        $.post("https://0r-carcontrol/ChangeMusic", JSON.stringify({
            icon: true,
            type: 'sag'
        }));
    });
});

function FadeIn(Object, Timeout) {
    $(Object).fadeIn(Timeout).css('display', 'block');
} 

function FadeOut(Object, Timeout) {
    $(Object).fadeOut(Timeout)
    setTimeout(function(){
        $(Object).css("display", "none");
    }, Timeout)
}

function UpdateVehData(data) {
    if (data.mode == 'normal') {
        if (data.mode == mode) { return; }
        mode = 'normal'
        var resimElementi = $("#top-bg"); 

       
        resimElementi.addClass('fade-out');

        
        resimElementi.fadeOut(500, function() {
            
            resimElementi.attr('src', 'img/mavibg.png');
            
            resimElementi.fadeIn(500);
            $('.mainscreen .top-main-screen .header-cont .header-name .text1').css('color', '#276EF8')
            $('.mainscreen .top-main-screen2 .fuel').css('background', '#276EF8')
            $('.mainscreen .top-main-screen2 .miles').css('background', '#276EF8')
        });
        var resimElementi2 = $("#header"); 

       
        resimElementi2.addClass('fade-out');

        
        resimElementi2.fadeOut(500, function() {
            
            resimElementi2.attr('src', 'img/blue-header-bg.png');
            
            resimElementi2.fadeIn(500);
        });

        resimElementi2.addClass('fade-out');

        var resimElementi3 = $("#hava"); 
        
        resimElementi3.fadeOut(500, function() {
            
            resimElementi3.attr('src', 'img/hava.png');
            
            resimElementi3.fadeIn(500);
        });
        $.post("https://0r-carcontrol/normalmode2");
    } else if (data.mode == 'drift') {
        if (data.mode == mode) { return; }
        mode = 'drift'
        var resimElementi = $("#top-bg"); 

       
        resimElementi.addClass('fade-out');

        
        resimElementi.fadeOut(500, function() {
            
            resimElementi.attr('src', 'img/turuncubg.png');
            
            resimElementi.fadeIn(500);
            $('.mainscreen .top-main-screen .header-cont .header-name .text1').css('color', '#f86227')
            $('.mainscreen .top-main-screen2 .fuel').css('background', '#f86227')
            $('.mainscreen .top-main-screen2 .miles').css('background', '#f86227')
        });
        var resimElementi2 = $("#header"); 

       
        resimElementi2.addClass('fade-out');

        
        resimElementi2.fadeOut(500, function() {
            
            resimElementi2.attr('src', 'img/turuncu-header-bg.png');
            
            resimElementi2.fadeIn(500);
        });
        var resimElementi3 = $("#hava"); 
        
        resimElementi3.fadeOut(500, function() {
            
            resimElementi3.attr('src', 'img/turuncuhava.png');
            
            resimElementi3.fadeIn(500);
        });
        $.post("https://0r-carcontrol/driftmode2");
    } else if (data.mode == 'sport') {
        if (data.mode == mode) { return; }
        mode = 'sport'
        var resimElementi = $("#top-bg"); 

       
        resimElementi.addClass('fade-out');

        
        resimElementi.fadeOut(500, function() {
            
            resimElementi.attr('src', 'img/kirmizibg.png');
            
            resimElementi.fadeIn(500);
            $('.mainscreen .top-main-screen .header-cont .header-name .text1').css('color', '#f82727')
            $('.mainscreen .top-main-screen2 .fuel').css('background', '#f82727')
            $('.mainscreen .top-main-screen2 .miles').css('background', '#f82727')
        });


        var resimElementi2 = $("#header"); 

       
        resimElementi2.addClass('fade-out');

        
        resimElementi2.fadeOut(500, function() {
            
            resimElementi2.attr('src', 'img/kirmizi-header-bg.png');
            
            resimElementi2.fadeIn(500);
        });
        var resimElementi3 = $("#hava"); 
        
        resimElementi3.fadeOut(500, function() {
            
            resimElementi3.attr('src', 'img/kirmizihava.png');
            
            resimElementi3.fadeIn(500);
        });
        $.post("https://0r-carcontrol/sportmode2");
    }

    if (data.door1) {
        $('.left-d-f').css('background-image', 'url(img/selected.png)')
        FadeIn('.left-d-f-select', 350)
    } else {
        $('.left-d-f').css('background-image', 'url(img/select.png)')
        FadeOut('.left-d-f-select', 350)
    }
    if (data.door2) {
        $('.left-d-b').css('background-image', 'url(img/selected.png)')
        FadeIn('.left-d-b-select', 350)
    } else {
        $('.left-d-b').css('background-image', 'url(img/select.png)')
        FadeOut('.left-d-b-select', 350)
    }
    if (data.door3) {
        $('.right-d-f').css('background-image', 'url(img/selected.png)')
        FadeIn('.right-d-f-select', 350)
    } else {
        $('.right-d-f').css('background-image', 'url(img/select.png)')
        FadeOut('.right-d-f-select', 350)
    }
    if (data.door4) {
        $('.right-d-b').css('background-image', 'url(img/selected.png)')
        FadeIn('.right-d-b-select', 350)
    } else {
        $('.right-d-b').css('background-image', 'url(img/select.png)')
        FadeOut('.right-d-b-select', 350)
    }
    if (data.hood) {
        $('.hood').css('background-image', 'url(img/selected.png)')
        FadeIn('.hoodselect', 350)
    } else {
        $('.hood').css('background-image', 'url(img/select.png)')
        FadeOut('.hoodselect', 350)
    }
    if (data.trunk) {
        $('.trunk').css('background-image', 'url(img/selected.png)')
        FadeIn('.trunkselect', 350)
    } else {
        $('.trunk').css('background-image', 'url(img/select.png)')
        FadeOut('.trunkselect', 350)
    }
    if (data.window) {
        windows = false
        $('.windows').css('background-image', 'url(img/select.png)')
        FadeOut('.window1', 350)
        FadeOut('.window2', 350)
    } else {
        windows = true
        $('.windows').css('background-image', 'url(img/windows.png)')
        FadeIn('.window1', 350)
        FadeIn('.window2', 350)
    }
}



window.onload = function(e) {
    window.addEventListener("message", function(event) {
        var data = event.data;
        switch (data.action) {
            case 'updatemode':
                UpdateVehData(data)
                break;
            case 'close3':
                if (vehicle) {
                    vehicle = false
                    $('.vehicle-container').css('display', 'none')
                    $('.mainscreen').css('display', 'none')
                    $.post("https://0r-carcontrol/close");
                }
                break;
            case 'open':
                UpdateSeats(data.seats)
                FadeIn('.mainscreen', 300)
                break;
            case 'thick':
                UpdateVehData(data.vehdata)
                driver = data.driver
                $('.km').html("KM <span>"+data.mileage.toFixed(2)+"</span>")
                $('.locations .location1').html(data.street)
                $('.locations .location2').html(data.zone)
                $('.miles .text').html(Math.floor(data.mesafe)+'<span>M</span>')
                $('.vehicle .header .name1').html(data.displayName)
                $('.vehicle .header .name2').html(data.class)
                if (data.fuel > 100) { data.fuel = 100}
                if (data.fuel < 0) { data.fuel = 0}
                $('.fuel .text').html('<span style="font-size: .9vh;">%</span>'+Math.floor(data.fuel))
                var resimElementi = $("#araba");
                resimElementi.attr('src', 'https://docs.fivem.net/vehicles/'+data.displayName.toLowerCase()+'.webp');
                $('#body').css('width', Math.floor(data.body/10)+'%')
                $('#body2').html(Math.floor(data.body/10)+'%')
                $('#engine').css('width', Math.floor(data.engine/10)+'%')
                $('#engine2').html(Math.floor(data.engine/10)+'%')
                $('#tyre').css('width', Math.floor(data.tyre/10)+'%')
                $('#tyre2').html(Math.floor(data.tyre/10)+'%')
                $('#petrol').css('width', Math.floor(data.petrol/10)+'%')
                $('#petrol2').html(Math.floor(data.petrol/10)+'%')
                $('.weather .header2').html(data.hava)
                if (Math.floor(data.body/10) <= 50) {
                    $('.safe .text').html('WARNING')
                } else if (Math.floor(data.body/10) <= 30) {
                    $('.safe .text').html('DANGER')
                }
                break;
            case 'updatemyplaylist':
                UpdateMyPlaylist(data.data, 'myplaylist')
                myname = data.name
                $('.textler .header2').html(myname+'’s Playlist')
                break
            case 'MusicTime': 
                music_time = data.payload;
                const colorRange = document.getElementById("colorRange");
                const maxDuration = music_time.maxDuration;
                let newValue = 0;
                if (maxDuration > 0) {
                    newValue = Math.max(0, Math.min((data.payload.timeStamp / maxDuration) * 100, 100));
                }
                colorRange.style.setProperty('--value', newValue + '%');
                colorRange.value = newValue;
                break;
            case 'ChangeMusic':    
                $.post("https://0r-carcontrol/ChangeMusic", JSON.stringify({
                    id: musicid
                }));
                break
            case 'UpdateName':
                $('.music-name .name1').html(data.name)
                break
        }
    });
};


$(document).on("keydown", function() {
    if (event.repeat) {
        return;
    }
    switch (event.keyCode) {
        case 27:
            FadeOut(".mainscreen", 300)
            FadeOut(".vehicle-container", 300)
            $.post("https://0r-carcontrol/close");
            break;
    }
});

function UpdateMyPlaylist(playlist, type) {
    $(".playlist").html("");
    if (type == 'myplaylist') {
        for (var k in playlist) { 
            id = Number(k)+1
            let html = `
                <div class="song">
                    <img id="song" src="img/song.png" alt="" data-url="${playlist[k].url}" data-name="${playlist[k].name}" data-id="${id}">
                    <div class="name">${playlist[k].name}</div>
                    <img id="trash" src="img/trash.png" alt="" data-url="${playlist[k].url}" data-name="${playlist[k].name}" data-sqlid="${playlist[k].id}">
                </div>
            `
            $(".playlist").append(html);
        }
    } else if (type == 'allplaylist') {
        for (var k in playlist) { 
            let html = `
                <div class="song">
                    <img id="song" src="img/song.png" alt="" data-url="${playlist[k].url}" data-name="${playlist[k].name}">
                    <div class="name">${playlist[k].name}</div>
                    <div class="submit2" data-url="${playlist[k].url}" data-name="${playlist[k].name}"></div>
                </div>
            `
            $(".playlist").append(html);
        }
    }
}

function UpdateSeats(seats) {
    $('.seats').html('');
    for (let i = 0; i < seats; i++) {
        let style;
        if (i % 2 === 0) {
            style = 'border-radius: .463vh 0vh 0vh .463vh;';
        } else {
            style = 'border-radius: 0vh .463vh .463vh 0vh;';
        }

        if (i - 1 == 0) {
            let html = `
                <div data-id="${i - 1}" id="seat" class="seat" style="${style}">
                    <img id="seat-icon" src="img/seat.png" alt="">
                    <div class="text1">FRONT SEAT</div>
                    <div class="text2">CLICK TO SELECT</div>
                </div>
            `;
            $(".seats").append(html);
        }else if (i - 1 == -1) {
            let html = `
                <div data-id="${i - 1}" id="seat" class="seat" style="${style}">
                    <img id="seat-icon" src="img/seat.png" alt="">
                    <div class="text1">DRIVER SEAT</div>
                    <div class="text2">CLICK TO SELECT</div>
                </div>
            `;
            $(".seats").append(html);
        
        } else if (i - 1 >= 0) {
            let html = `
                <div data-id="${i - 1}" id="seat" class="seat" style="${style}">
                    <img id="seat-icon" src="img/seat.png" alt="">
                    <div class="text1">BACK SEAT ${i-1}</div>
                    <div class="text2">CLICK TO SELECT</div>
                </div>
            `;
            $(".seats").append(html);
        }
    }
}