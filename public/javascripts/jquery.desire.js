jQuery.fn.insertDesireList = function() {
  var li = document.createElement('li');
  var div = document.createElement('div');
    
  div.className = 'price';
  li.appendChild(document.createTextNode(this.children('[type!=hidden]').val()));
  li.appendChild(div);
  
  return this.after(li);
};