//inspired by http://paperjs.org/examples/rounded-rectangles/
// http://paperjs.org/tutorials/getting-started/working-with-paper-js/
//how to save this stuff http://paufler.net/BrettCode/paperJS_Tutorial/paperJS-031-SavingImageOutput.html ???
var mousePoint = view.center;
var amount = 45;
var colors = ['red', 'pink', 'orange', 'yellow'];

var bC = 0; // variable to track image number

for (var i = 0; i < amount; i++) {
	var rect = new Rectangle([0, 0], [45, 25]);
	rect.center = mousePoint;
	var path = new Path.Rectangle(rect, 7);
	path.fillColor = Color.random();
	var scale = (1 - i / amount) * 10;
	path.scale(scale);
}

function onMouseMove(event) {
	mousePoint = event.point;
}

var children = project.activeLayer.children;
function onFrame(event) {
	for (var i = 0, l = children.length; i < l; i++) {
		var item = children[i];
		var delta = (mousePoint - item.position) / (i + 5);
		item.rotate(Math.tan((event.count + i) / 10) * 7);
		if (delta.length > 0.1)
			item.position += delta;
	}
}

var children = project.activeLayer.children;
function onMouseDown(event) {
	for (var i = 0, l = children.length; i < l; i++) {
		var item = children[i];
		item.fillColor = Color.random();
	}
}
