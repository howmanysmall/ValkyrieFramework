var str = "{\n";

$(".color_box").each(function(_,e) {
    str += "\t";
    var i = parseInt(e.innerHTML);
    if (isNaN(i)) {
        str += "[\"" + e.innerHTML.substr(1, e.innerHTML.length - 2) + "\"]"; // Strip whitespace
    }
    else {
        str += "[" + i + "]";
    }
    
    var rgbVal = $(e).attr("data-rgb");
    var comp = rgbVal.substr(4, rgbVal.length - 5).split(",");
    var ret = "new3(";
    for (i = 0; i < comp.length; i++) {
    	console.log(parseFloat(comp[i]) / 255 + ",");
    	ret += (parseFloat(comp[i]) / 255) + ",";
    }
    str += " = " + ret.substr(0, ret.length - 1) + ");\n";
});

console.log(str + "};");