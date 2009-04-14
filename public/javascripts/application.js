// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var $j = jQuery.noConflict();

function DesireList (jquery) {
  this.list = jquery.get(0);
}

DesireList.prototype.insert = function(name) {
  var li = document.createElement('li');
  li.appendChild(document.createTextNode(name));
  
  var price = document.createElement('div');
  $j(price).addClass('price');
  li.appendChild(price);
  
  this.list.insertBefore(li, $j('ul#desire > li:not(:first)').get(0));
  return this;
}

$j(function() {
   $j('ul#desire > li:first').hide();
   
   $j('a#create-button').click(function() {
                               $j('ul#desire > li:first').show();
                               $j('input#want_name').val('').focus();
                               return false;
                               });
   
   $j('input#want_name').blur(function() {
                              $j('li > form').get(0).onsubmit();
                              });
})