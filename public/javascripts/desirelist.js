/* utilities and methods related with desire list. */

(function() {

var window = this,
	undefined,
	Desire = window.Desire = function() {},
	
	DesireList = window.DesireList = window.dl = function(s) {
		(DesireList.fn.ref[s] === undefined) && (DesireList.fn.ref[s] = new DesireList.fn.init(s));
		return DesireList.fn.ref[s];
	};
	
Desire.prototype = Desire.fn = {
	show: function(data) {
		$('ul.details input[type!=hidden]').each(function(index, elem) {
			$(elem).val( data[elem.className] ? data[elem.className] : '');
		});
	},
	over: function(o) {
		var d = window.desires, sync = DesireList.fn.sync;
		
		$('#desire-attribute').show();
		$('#desire-meta').hide();

		$(this).addClass('hovering');
		DesireList.fn.hovering = $(this).find('a').attr('href').split('/').pop();
	 
		(DesireList.fn.selected === undefined) && (sync) && (Desire.prototype.show(d[DesireList.fn.hovering])); 
	},
	out: function() {
		$(this).removeClass('hovering');
		
		if (DesireList.fn.selected === undefined)
		{
			$('#desire-attribute').hide();
			$('#desire-meta').show();
		}
	},
	click: function() {
		var d = window.desires, sync = DesireList.fn.sync, s = DesireList.fn.selected,
			id = $(this).find('a').attr('href').split('/').pop();

		$(this).toggleClass('selected');
		
		if (s === undefined) {
			DesireList.fn.selected = id;
			$('ul.details').css({ 'background-color': '#ffefe0' })
			$('#desire-attribute').css({ 'border-color': '#cce8cf' })
		} else if (s == id) {
			DesireList.fn.selected = undefined;
			$('ul.details').css({ 'background-color': '#fff' })
			$('#desire-attribute').css({ 'border-color': '#fff' })
		} else {
			$('ul.desires li').current('/desires/' + s).removeClass('selected');
			Desire.fn.show(desires[id]);
			DesireList.fn.selected = id;
		};
			
	},
};
	
DesireList.prototype = DesireList.fn = {
	hovering: undefined,
	selected: undefined,
	sync: false,
	ref: new Object(),
	
	init: function(s) {
		this.d = {},
		this.m = {},
		this.root = $(s);
		
		this.d.input = $(s).find('ul.desires li[class=input]');
		this.d.name = $(s).find('#desire_name');
		this.d.list = $(s).find('ul.desires li[class!=input]');
		this.d.create = $('#new-button');
		this.d.form = $(s).find('#new_desire');
		
		this.m.value = undefined;
		this.m.list = $(s).find('ul.details li');
		this.m.inputs = $(s).find('ul.details li input[type!=hidden]');
		
	},
	
	// main display logic.
	render: function() {
		this.setup();
		this.operations();
	},	
	setup: function() {
		var l = this;
	
		this.d.input.hide();
		this.root
			.find('#desire_submit').hide().end()
			.find('li a').hideAnchorBeavhior();
 
		this.d.create.click(function() {
			l.d.input.show();
			l.d.name.focus();
			return false;
		});
 
		this.d.form.submit(function() { return false; });
	},
	operations: function() {
		var l = this;
		
		this.d.list
			.hover(Desire.fn.over, Desire.fn.out)
			.click(Desire.fn.click);
		
		this.d.name
			.keypress(function(e) { (e.which == 13) && $(this).blur(); })
			.blur(function() {
				if ($(this).val() == '') { l.d.input.hide(); } 
				else {
					$.dpost('/desires', l.d.form.serialize(),
						function(e) {
							$('ul.desires li.input')
								.insertDesireList(e.path)
								.find('#desire_name').val('').end().hide();
						},
						function() { l.d.input.addClass('loading'); },
						function() { l.d.input.removeClass('loading'); }
					);
				};
			});
 
		this.m.list.click(function() { $(this).children().focus(); });
		
		this.m.inputs
			.focus(function() { 
				l.m.value = $(this).val();
				$(this).addClass('focused'); 
				
				l.selected = (l.selected) ? l.selected : l.hovering;
			})
			.keypress(function(e) { (e.which == 13) && $(this).blur(); })
			.blur(function() {
				var id = l.selected, url = '/desires/' + id, self = this;
			
				if ($(this).val() == '' || $(this).val() == l.m.value) {} // do nothing
				else { 
					$.dpost(url, $(this).add('input[type=hidden]').serialize(),
						function() {
							window.desires[id][self.className] = $(self).val();
							
							if (self.className == 'price') {
								$('ul.desires li').current(url).find('span').text($(self).val());
							};
						},
						function() {
							$('ul.desires li').current(url)
								.find('span').hide().end()
								.addClass('loading');
						},
						function() {
							$('ul.desires li').current(url)
								.find('span').show().end()
								.removeClass('loading');
						}
					);
				};
				$(this).removeClass('focused');
				
				l.selected = undefined;
			});
	},
};

DesireList.fn.init.prototype = DesireList.fn;

/* image preloading */

var p = window.preload = new Object();
p['done'] = new Image(), p['oops'] = new Image(), p['spin'] = new Image();
p['spin'].src = '/images/spinning.gif', p['oops'].src = '/images/oops.png', p['done'].src = '/images/done.png';

/* get data */

$.get('/desires', function(data) { eval('window.desires = ' + data); }, 'json');
var sync = function() {
	if (typeof window.desires == 'object') { DesireList.fn.sync = true; }
	else { setTimeout(sync, 200); }
};
sync();

})()

