jQuery.fn.insertDesireList = function(path) {
	var li = document.createElement('li');
	var span = document.createElement('span');
	var a = document.createElement('a');
	
	span.className = 'price';
	a.href = path;
	a.style.textDecoration = 'none';
	a.innerHTML = jQuery('#desire_name').val();
	a.onclick = function() { return false; };
	li.appendChild(a);
	li.appendChild(span);
	
	if (typeof desires == 'object') {
		var id = path.split('/').pop();
		desires[id] = { name: a.innerHTML, id: id };
		jQuery(li).hoverOverDesireList();
	}
	
	return this.after(li);
};

jQuery.fn.hoverOverDesireList = function() {
	this.hover(
		function() {
			jQuery('#desire-meta').hide();
			jQuery('#desire-attribute').show();
	
			jQuery(this).addClass('selected');
			
			if (typeof desires == 'object') {
				window.current_selected_item = jQuery(this);
				window.current_selected_id = jQuery(this).children('a:first').attr('href').split('/').pop();
				
				(function(data) {
					jQuery('#desire-details input[type!=hidden]').each(function(index, elem) { 
						jQuery(elem).val(
							data[elem.className] ? data[elem.className] : '' ); 
					});
				})(desires[current_selected_id]);
			}
		},
		function() { jQuery(this).removeClass('selected'); }
	);
	return this;	
};

function rgb2percents (rgb) {
    if (rgb.substring(0,1)=="#") {
		rgb = rgb.substring(1,rgb.length);
    }
    var percentArray = new Array(3);
    count = 0;
    for (component = 0; component<3; component++) {
		rgbComponent = rgb.substring(component*2,(component*2)+2);
		percentArray[component] =
        Math.round(100 * (parseInt("0x" + rgbComponent)/255));
    }
    return percentArray;
};

/* always fade out to #fff */
function doTransition (elem, bgColor, bdColor, timeSoFar, durationTime) {
	var proportionSoFar = timeSoFar/durationTime;
	
	var currentBgColor = "rgb(";
	var currentBdColor = "rgb(";
	
    for (component=0; component<3; component++) {
		var currentBgComponent = 
			Math.round(bgColor[component] + proportionSoFar * (100 - bgColor[component]));
		
		var currentBdComponent = 
			Math.round(bdColor[component] + proportionSoFar * (100 - bdColor[component]));
		
		currentBgColor += currentBgComponent + "%" + (component<2 ? "," : ")");
		currentBdColor += currentBdComponent + "%" + (component<2 ? "," : ")");
    }
	
    elem.style.backgroundColor = currentBgColor;
    elem.style.borderColor = currentBdColor;
	
	timeSoFar += 100;
    if (timeSoFar >= durationTime) {
		elem.style.backgroundColor = '#fff';
		elem.style.borderColor = '#fff';
		return;
    }
    var doNextRound = function() {
		doTransition(elem, bgColor, bdColor, timeSoFar, durationTime);
    }
    setTimeout(doNextRound, 100);
};

jQuery.fn.highlightWithBorder = function(bgColor, bdColor, duration) {
	this.each(function(index, elem) {
		doTransition (elem, rgb2percents(bgColor), rgb2percents(bdColor), 0, duration);
	});
	return this;
};