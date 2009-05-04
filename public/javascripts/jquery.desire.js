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
	
	if (DesireList.fn.sync) {
		var id = path.split('/').pop();
		window.desires[id] = { name: a.innerHTML, id: id };
		jQuery(li).hover(window.Desire.fn.over, window.Desire.fn.out).click(window.Desire.fn.click);
	}

	return this.after(li);
};

jQuery.fn.current = function(key) {
	return this.filter(function() {
		return ($(this).find('a').attr('href') == key) ? true : false; 
	});
};

jQuery.dpost = function(u, d, s, b, c) {
	jQuery.ajax({
		type: "POST",
		url: u,
		data: d,
		dataType: "json",
		success: function(data) {
			jQuery('#status-area').css({
				'opacity':'100',
				'background':'#fff url(/images/done.png) no-repeat scroll 15px center' 
			}).text(data.message).highlightWithBorder('#ffffff', '#cce8cf', 1000);
		
			setTimeout(function() {
				$('#status-area').animate({ opacity: '0' }, 3000);
			}, 3000);
			
			(typeof s == 'function') && (s.apply(this, [data]));
		},
		beforeSend: b,		
		complete: c,
	});
};

jQuery.fn.hideAnchorBeavhior = function() {
	return this.css({ 'text-decoration': 'none'}).click(function() { return false; });
};

jQuery.fn.highlightWithBorder = function(bgColor, bdColor, duration) {
	return this.each(function(index, elem) {
		doTransition (elem, rgb2percents(bgColor), rgb2percents(bdColor), 0, duration);
	});
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