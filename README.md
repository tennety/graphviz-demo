## Overview

- Graphs and [graphviz](http://graphviz.org)
  - Graphing library
  - Graph language
  - Can use multiple rendering algorithms
- Graph [gem](http://github.com/seattlerb/graph)
  - Cute DSL
  - Inline
  - Images vs text output
- [Canviz](http://code.google.com/p/canviz)
  - Uses [Prototype.js](http://prototypejs.org)
  - Parses dotx, renders SVG
  - [Demo site](http://ryandesign.com/canviz)
    - Can render from a remote file
    - Or parse text on the client side

## About this app

- Uses Sinatra
  - Gemfile includes Shotgun as a dev dependency
  - Starts up by running `ruby app.rb` on:
    - localhost:4567 with Sinatra
    - localhost:9393 with Shotgun
- Needs Graphviz installed on the machine
  - See the Graphviz site on how to get it
- Navigation/Toolbar
  - Home
    - Displays the index page
  - Load image
    - Takes a hard-coded node/edge matrix
    - Builds a Graph Ruby object
    - Saves it as an image in /images
    - Renders that image in div#graph
  - Load dotx
    - Takes the same hard-coded matrix
    - Builds the Graph object
    - Runs it through Graphviz via IO.popen
    - Renders the text result to div#graph_data
    - On dom load, Canviz:
      - Reads the text from that div
      - Parses it and renders it to div#graph
  - Build dynamically
    - Allows user to build the matrix by adding 'edges'
    - Posts the form via Ajax to /build where:
      - The Graph object is built
      - Run through Graphviz via IO.popen
      - The dotx text is returned as the Ajax response
    - On success of the Ajax request, Canviz:
      - Parses the response and renders it to div#graph

## Play around!
Feel free to experiment/extend the app. For example, including the line:
      graph.boxes
after the graph object has been created renders the nodes as boxes instead of ovals.

On the front-end, in a JavaScript console, you could do the following:
      var c = new Canviz('graph', 'try.txt')
and see Canviz render the text file (public/try.txt) via Ajax.
