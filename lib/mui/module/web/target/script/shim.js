if (!window.requestAnimationFrame) {
	if (window.webkitRequestAnimationFrame) {
		window.requestAnimationFrame = window.webkitRequestAnimationFrame;
	} else if (window.mozRequestAnimationFrame) {
		window.requestAnimationFrame = window.mozRequestAnimationFrame;
	} else if (window.msRequestAnimationFrame) {
		window.requestAnimationFrame = window.msRequestAnimationFrame;
	} else if (window.oRequestAnimationFrame) {
		window.requestAnimationFrame = window.oRequestAnimationFrame;
	} else {
		window.requestAnimationFrame = function(callback, element) {
			window.setTimeout(callback, 16);
		};
	}
}
document.ontouchmove = function(e) { e.preventDefault(); };