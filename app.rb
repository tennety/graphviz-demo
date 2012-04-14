require 'sinatra'
require 'haml'
require 'graph'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

before do
  edges = [["a", "b"], ["a", "c"], ["b", "c"]]
  @graph = Graph.new "demo"
  edges.each do |(n1, n2)|
    @graph.edge n1, n2
  end
end

get '/image' do
  @graph.save File.join(APP_ROOT, 'public/images/demo'), 'png'

  haml :index
end

get '/dotx' do
  str = IO.popen("/usr/bin/dot -Txdot", "w+")
  str.puts @graph.to_s
  str.close_write

  haml :graph, :locals => {:dotx => str.readlines.join}
end

__END__

@@ layout
%html
  %head
    %script{:type => 'text/javascript', :src => 'public/js/prototype.js'}
    %script{:type => 'text/javascript', :src => 'public/js/path.js'}
    %script{:type => 'text/javascript', :src => 'public/js/canviz.js'}
    %link{:rel => 'stylesheet', :type => 'text/css', :href => 'canviz.css'}
  %body
    = yield

@@ index
.graph
  %img{ :src => 'images/demo.png' }

@@ graph
#graph
  = dotx
#debug_output{:style => 'display: none;'}
