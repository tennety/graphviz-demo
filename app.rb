require 'sinatra'
require 'haml'
require 'graph'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

helpers do
  def to_dot(graph, method="dot")
    str = IO.popen("/usr/bin/#{method} -Txdot", "w+")
    str.puts graph.to_s
    str.close_write
    str.readlines.join
  end

  def graph_methods
    %w{dot twopi neato circo fdp}
  end
end

before do
  edges = [["Nodes and Edges", "Graph"],
           ["Graph", "Graphviz"],
           ["Graphviz", "Canviz"]]
  @graph = Graph.new "demo"
  edges.each do |(n1, n2)|
    @graph.edge n1, n2
  end
end

get '/' do
  haml :index
end

get '/image' do
  @graph.save File.join(APP_ROOT, 'public/images/demo'), 'png'

  haml :graph_image
end

get '/dotx' do
  dotx = to_dot(@graph)
  haml :graph, :locals => {:dotx => dotx}
end

get '/dynamic' do
  haml :dynamic
end

post '/build' do
  graph = Graph.new("demo")
  params["from"].each_with_index do |f, i|
    graph.edge f, params["to"][i]
  end
  to_dot(graph, params["method"])
end

__END__

@@ layout
!!!5
%html
  %head
    %script{:type => 'text/javascript', :src => 'js/bootstrap.min.js'}
    %script{:type => 'text/javascript', :src => 'js/prototype.js'}
    %script{:type => 'text/javascript', :src => 'js/path.js'}
    %script{:type => 'text/javascript', :src => 'js/canviz.js'}
    %link{:rel => 'stylesheet', :type => 'text/css', :href => 'css/bootstrap.css'}
    %link{:rel => 'stylesheet', :type => 'text/css', :href => 'css/bootstrap-responsive.css'}
  %body{:style => 'padding-top: 40px'}
    %title Graphviz | Graph Gem | Canviz
    .navbar.navbar-fixed-top
      .navbar-inner
        .container
          %ul.nav
            %li
              %a{:href => '/'} Home
            %li
              %a{:href => '/image'} Load Image
            %li
              %a{:href => '/dotx'} Load Dotx
            %li
              %a{:href => '/dynamic'} Build dynamically
    .container
      %section#app
        .page-header
          %h1 My Awesome Graph/Canviz Demo
        = yield
        .row
          #debug_output{:style => 'display: none;'}

@@ index
.row
  #graph.span3

@@ graph_image
.row
  #graph.span3
    %img{ :src => 'images/demo.png' }

@@ graph
%script{:type => 'text/javascript', :src => 'js/demo.js'}
.row
  #graph.span3
.row
  #graph_data{:style => 'display: none;'}
    != "#{dotx}"

@@ dynamic
%script{:type => 'text/javascript', :src => 'js/dynamic.js'}
%script#edge_template{:type => 'text/template'}
  <div class='edge_row'>
  <input type='text' placeholder='From' name='from[]' />
  <input type='text' placeholder='To' name='to[]'     />
  </div>
.row
  %form.span5.graph_builder{:action => '/build', :method => 'post'}
    .submit.btn-group
      %select.btn{:name => 'method'}
        - graph_methods.map do |m|
          %option{:value => m}
            = m
      %button{:class => 'add_edge btn'} Add edge
      %button{:class => 'submit btn'} Build it!
    .edge_fields
  #graph.span5
