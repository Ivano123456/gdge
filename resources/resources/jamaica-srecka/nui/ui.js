
$(document).ready(function(){
 window.addEventListener( 'message', function( event ) {
        var item = event.data;
        if ( item.showPlayerMenu == true ) {
            $('body').css('background-color','transparent');

            $('#divp').css('display','block');
            if (typeof window.startSreckaGame === 'function') {
                window.startSreckaGame(item.canWin === true);
            }
        } else if ( item.showPlayerMenu == false ) { // Hide the menu

            $('#divp').css('display','none');
            $('body').css('background-color','transparent important!');
            $("body").css("background-image","none");
            document.location.reload(true);
        }
 } );
        
	
        $(document).keyup(function(e) {
            if ( e.keyCode == 27 ) {
             $.post('https://jamaica-srecka/closeButton', JSON.stringify({}));
           }
        });

})
