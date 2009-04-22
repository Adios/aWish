// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var img_done = new Image;
var img_oops = new Image;
var img_spin = new Image;

img_spin.src = '/images/spinning.gif';
img_done.src = '/images/done.png';
img_oops.src = '/images/oops.png';

$(function() {
	$.get('/desires', function(data) { eval('desires = ' + data); }, 'json');
  
	$('#desire-list li.input').hide()
	$('#desire_submit').hide();
	$('#desire-list li a').css({ 'text-decoration': 'none'}).click(function() { return false; });
  
	$('#desire-list li:not(:first)')
		.hoverOverDesireList();
  
	$('#new-button')
		.click(function() {
			$('#desire-list li.input').show()
			$('#desire_name').focus();
			return false;
		});
  
	$('#new_desire')
		.submit(function() { return false; });
  
	$('#desire_name')
		.keypress(function(e) { (e.which == 13) && $(this).blur(); })
		.blur(function() {
			if ($(this).val() == '') { $('#desire-list li.input').hide(); } 
			else {
				$.ajax({
					type: "POST",
					url: "/desires",
					data: $('#new_desire').serialize(),
					success: function(data) {
						$('#status-area')
							.css({
								'opacity':'100',
								'background':'#fff url(/images/done.png) no-repeat scroll 15px center' 
							})
							.text(data.message)
							.highlightWithBorder('#ffffff', '#cce8cf', 1000);
							
							setTimeout(function() {
								$('#status-area').animate({ opacity: '0' }, 3000);
							}, 3000);
										
						$('#desire-list li.input')
							.insertDesireList(data.path)
							.find('#desire_name')
								.val('')
							.end()
							.hide();
					}, 
					dataType: "json",
					beforeSend: function() {
						$('li.input').css({ 'background':'#fff url(/images/spinning.gif) no-repeat scroll 98% center'});
					},
					complete: function() {
						$('li.input').css({ 'background':'#fff' });
					}
				});
			}
		})
		;
  
	$('#desire-details li input[type!=hidden]')
		.parent()
			.click(function() { $(this).children().focus(); })
		.end()
		.focus(function() { 
			window.current_input_value = $(this).val();
			window.current_manipulate_item = window.current_selected_item;
			$(this).addClass('focused'); 
		})
		.keypress(function(e) { (e.which == 13) && $(this).blur(); })
		.blur(function() {
			var self = $(this);
			if ($(this).val() == '' || $(this).val() == window.current_input_value) { /*do nothing*/ }
			else { $.ajax({
				type: "POST",
				dataType: "json", 
				url: "/desires/" + window.current_selected_id, 
				data: $(this).add('input[type=hidden]').serialize(),
				success: function(data) {
					$('#status-area')
						.css({
							'opacity':'100',
							'background':'#fff url(/images/done.png) no-repeat scroll 15px center' 
						})
						.text(data.message)
						.highlightWithBorder('#ffffff', '#cce8cf', 1000);
					  
						setTimeout(function() {
							$('#status-area').animate({ opacity: '0' }, 3000);
						}, 3000);
		
					desires[window.current_selected_id][self.attr('class')] = self.val();
					
					if (self.attr('class') == 'price') {
						current_manipulate_item.find('span').text(self.val());
					}
				},
				beforeSend: function() {
					current_manipulate_item
						.find('span')
							.hide()
						.end()
						.css({ 
							'background-image':'url(/images/spinning.gif)',
							'background-repeat':'no-repeat',
							'background-attachment':'scroll',
							'background-position':'98% center'
						});
				},
				complete: function() {
					current_manipulate_item
						.css({ 'background-image':'none' })
						.find('span')
							.show();
				}
			});}
			$(this).removeClass('focused');
		});
});
