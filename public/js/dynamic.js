document.observe('dom:loaded', function() {
  $$('form.graph_builder button.add_edge')[0].observe('click', function(e){
    e.stop();
    var t = new Template($('edge_template').innerHTML);
    var f = $(this).up(1);

    f.select('.edge_fields')[0].insert(t.evaluate({}));
  });

  $$('form.graph_builder button.submit')[0].observe('click', function(e){
    e.stop();
    var f = $(this).up(1);
    var req = new Ajax.Request(f.readAttribute('action'), {
      parameters: f.serialize(true),
      onSuccess : function(transport){
        var c = new Canviz('graph');
        c.parse(transport.responseText);
      }
    });
  });
});
