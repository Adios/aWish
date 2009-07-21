$(function() {
	wl = new WishList( '#wish-list', '#content .status' );

	$( '#content' )
		.find( '.act-bar .create' )
			.click(function() { wl.create() })
		.end()
		.find( '.act-bar .destroy' )
			.click(function() { wl.destroy( $( '#wish-list li.selected' ) ) })
		.end()
		.find( '.act-bar .reorder' )
			.click(function() { wl.reorder() })
		.end()
		.find( '#wish-list li' )
			.live('click', function() { $(this).toggleClass('selected') });
});

(function() {
	var undefined,
		inputWindow = (function() {
			var i = document.createElement('input');
			i.setAttribute('type', 'text');
			i.setAttribute('class', 'input-window');
			return i;
		})(),

		entry = (function() {
			var l = document.createElement('li'),
				a = document.createElement('a'),
				s = document.createElement('span');

			a.setAttribute('class', 'name');
			s.setAttribute('class', 'price');

			l.appendChild(a);
			l.appendChild(s);
			return l;
		})(),

		wishlist = window.WishList = function( list, status ) {
			this.status = $( status );
			this.selector = list;
			this.init();
		};

	wishlist.prototype = {
		init: function() {
			this.list = $( this.selector );
			this.entries = this.entries || List( this.list[0] );
		},
		create: function() {
			var self = this;

			this.cwin = this.cwin || createWindow( '/desires', 'POST', 'item[name]', function(res) {
				var data = res.data;

				if (res.code == 200) {
					self.stealth(self.cwin, true)
					self.entries.insert( createEntry(data.path, data.item.name) );
					self.status.text(res.mesg);
				} else
					self.status.text(data.item.join(' '));
			});

			/* make toggle-able */
			if (this.isWindowToggled())
				this.stealth(this.cwin);
			else
				this.list.prepend(this.cwin);
		},
		destroy: function( selected ) {
			var self = this;

			/* close input window if exists */
			if (this.isWindowToggled()) this.create();

			selected.each(function() {
				var me = this;

				$.wish( $( 'a', this ).attr('href'), 'DELETE', function(res) {
					if (res.code == 200) {
						self.status.text(res.mesg);
						self.entries = self.entries.remove( $.inArray(me, self.list.children()) );
					} else {
						self.status.text(res.mesg);
					}
				});
			});
		},
		reorder: function() {
			var map = { '': 0, 'non-urgent': 1, 'urgent': 2, 'emergent': 3 },
				reg = /[\S]*gent/,
				revert = this.isWindowToggled(),

				/* fns define the order of comparing: priority->price->name */
				fns = [
					function( e ) {
						return reg.test(e.className) ? map[reg.exec(e.className)[0]] : map[''];
					},
					function( e ) {
						return parseFloat($( 'span', e ).text()) || -1;
					},
					function( e ) {
						return $( 'a', e ).text();
					}
				];

			if (revert) this.create();

			/* reverse toggle-able */
			if (!this.ordered) {
				this.entries.reorder({ fn: function( a, b ) { return compare(a, b, fns) } });
				this.ordered = true;
			} else {
				this.entries.reorder();
				this.ordered = false;
			}

			/* re-select the object, since original elem was replaced by reorder() */
			this.init();

			if (revert) this.create();
		},
		stealth: function( dom, clear_value ) {
			this.shadow = this.shdaow || document.createDocumentFragment();
			if (clear_value) dom.value = '';
			this.shadow.appendChild( dom );
		},
		isWindowToggled: function() {
			return this.list.children('input').length;
		}
	};

	function createEntry( href, text ) {
		return $( 'a', entry.cloneNode(true) ).attr('href', href).text(text).parent().get(0);
	}

	function createWindow ( url , type, name, callback ) {
		return $( inputWindow.cloneNode(true) ).attr('name', name).keypress(function(e) {
			var code = e.keyCode || e.which;

			if (code == 13) {	// return
				$.wish( url, type, callback, $(this).serialize() );
				return false;
			}
		}).get(0);
	};

	function compare( a, b, fns ) {
		if (fns.length > 0) {
			var fn = fns[0],
				aa = fn(a),
				bb = fn(b);

			if (aa == bb) return compare( a, b, fns.slice(1) );
			return (aa < bb) ? 1 : -1;
		}
		return 0;
	}

	$.extend({
		wish: function ( url, type, callback, data ) {
			switch (type) {
				case 'DELETE':
					type = 'POST'; data = '_method=delete&' + _token; break;
				case 'PUT':
					type = 'POST'; data = '_method=put&' + _token; break;
				case 'POST':
					data = data ? data + '&' + _token : _token; break;
				case 'GET':
				default: break;
			}

			$.ajax({
				dataType: 'json',
				type: type,
				url: url,
				success: callback,
				data: data
			});
		}
	});
})();
