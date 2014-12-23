require 'rubygems'
require 'neography'
require 'sinatra'
require 'uri'


get '/' do
  erb :index
end

get '/cmdb/:field/:q' do
  puts "Field: #{params[:field]}"
  puts "Query #{params[:q]}"
  erb :cmdb
end

post '/cmdb/add/:data' do
  puts "#{params[:data]}"

  request.body.rewind
  #  request_payload = JSON.parse request.body.read
  puts request.body.read
end



def show_relations(f,q)
  neo = Neography::Rest.new
  cypher_query = "match (a {#{f}:'#{q}'}) - [rel*] -> (b)"
  cypher_query << "return startNode(rel[-1]).desc,ID(startNode(rel[-1])),endNode(rel[-1]).desc,ID(endNode(rel[-1])),type(rel[-1])"
  neo.execute_query(cypher_query)["data"]
end


get '/search/:field/:q' do
  nodes = Array.new
  edges = Array.new
  show_relations(params[:field],params[:q]).each do |d|

    node_hash_source = { 'name' => d[0], 'group' => groupnum(d[0]), 'id' => d[1],'r' => setradius(d[0])}
    node_hash_target = { 'name' => d[2], 'group' => groupnum(d[2]), 'id' => d[3],'r' => setradius(d[2])}

    nodes << node_hash_source unless nodes.include? node_hash_source
    nodes << node_hash_target unless nodes.include? node_hash_target

    edges << {'source' => nodes.index(node_hash_source), 'target' => nodes.index(node_hash_target), 'value' => linkval(d[4]) }

  end
  { 'nodes' => nodes, 'links' => edges}.to_json
end

def linkval(name)
  if name == 'physical'
    8
  else
    3
  end
end

def setradius(name)
  case name
  when "Powerstrip"
    20
  when "Switch"
    30
  when "Networkcard"
    18
  when "Powersupply"
    19
  when "switch_port"
    18
  when "Server"
    40
  else
    20
  end
end

def groupnum(name)
  case name
  when "Powerstrip"
    2
  when "Switch"
    3
  when "Networkcard"
    4
  when "Powersupply"
    5
  when "switch_port"
    6
  when "Server"
    7
  else
    1
  end
end
