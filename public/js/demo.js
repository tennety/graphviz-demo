document.observe('dom:loaded', function() {
   var c = new Canviz('graph');
   c.parse($('graph_data').innerHTML.gsub('&gt;','>'));
});
