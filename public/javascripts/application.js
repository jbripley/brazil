// Brazil namespace
jQuery.brazil = {
  move: {
    scrollable: function(id) {
      var scrollablePos = $(id).position();
      
      $(window).scroll(function() {
        var bodyTop = $(document).scrollTop();
        var scrollableHeight = $(id).outerHeight();
        var endOfPagePos = $('body').outerHeight();

        if(endOfPagePos <= (bodyTop + scrollableHeight))
        {
          // Stop moving / scrolling element
        }
        else if(bodyTop > scrollablePos.top)
        {
          $(id).css({position:"absolute", top: bodyTop, left: scrollablePos.left});
        }
        else
        {
          $(id).css({position:"absolute", top: scrollablePos.top, left: scrollablePos.left});
        }
      });
    }
  },
  flash: {
    notice: function() {
      $.get('/flash/notice', function(response) {
        $('#notice').hide().empty().append(response).fadeIn('slow', function() {
          setTimeout('$("#notice").fadeOut()', 3000);
        });
      });
    },
    discard: function() {
      $.get('/flash/notice', function(response) {
      });
    }
  },
  manipulate: {
    syntax_highlight: function() {
      dp.SyntaxHighlighter.ClipboardSwf = '/javascripts/syntaxhighlighter/clipboard.swf';
      dp.SyntaxHighlighter.HighlightAll('code');
    }
  }
};