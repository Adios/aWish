// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $('#desire-list li')
    .eq(0)
      .hide()
    .end()
      .not(':first').hover(
        function() {
          $(this).addClass('selected');
        },
        function() {
          $(this).removeClass('selected');
      });
  
  $('#new-button')
    .click(function() {
      $('#desire-list li:first').show().children().focus();
    });
      
  $('#want_name')
    .blur(function() {
      if ($(this).val() == '') {
        $(this).parent().hide();
      } else {
        $.post("/wants", $(this).parent().children().serialize(), function(data) {
          $('#status').html(data);
            var value = $('#want_name').val();
            $('#want_name')
              .parent()
                .insertDesireList()
              .end()
                .val('').parent().hide();
        }, 'text');
      }
    })
    .keypress(function(e) {
      (e.which == 13) && $(this).blur();
    });
  
                            
});
