require 'sinatra'
require 'haml'
require 'graph'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

get '/' do
  edges = [["a", "b"], ["a", "c"], ["b", "c"]]
  graph = Graph.new "demo"
  edges.each do |(n1, n2)|
    graph.edge n1, n2
  end
  graph.save File.join(APP_ROOT, 'public/images/demo'), 'png'

  haml :index
end

__END__

@@ index
%html
  %body
    %div.graph
      %img{ :src => 'images/demo.png' }
