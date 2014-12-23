#!/usr/bin/ruby

require 'json'
require 'rest-client'
require 'pp'

class RGraph

  def initialize
    @url = 'http://localhost:7474/db/data/cypher'
  end

  def create_node (label,attr={})
    query = ''  # holds the final query string
    attributes = '' # holds the attribute portion of the query, if any
    if attr.size == 0
      query += "CREATE (:#{label});"
    else
      attributes += '{ '
      attr.each do |key,value|
        attributes += "#{key.to_s}: '#{value}',"
      end
      attributes.chomp!(',') # Neo4j hates extra commas!
      attributes += ' }'
      query += "CREATE (:#{label} " + attributes + ');'
    end
    c = {
        "query" => "#{query}",
        "params" => {}
    }

    pp c
    RestClient.post @url, c.to_json, :content_type => :json, :accept => :json
  end

  def create_directed_relationship (from_node, to_node, rel_type)
    query = ''  # Holds the final query string
    attributes = '' # holds identifying attributes, if any
    query += "MATCH ( a:#{from_node[:type]} "
    from_node.each do |key,value|
      next if key == :type # Don't count "type" as an attribute
      attributes += "#{key.to_s}: '#{value}',"
    end
    attributes.chomp!(',') # Get rid of extra comma
    query += "{ #{attributes} }),"
    attributes = '' # Reset to process next MATCH statement
    query += " ( b:#{to_node[:type]} "
    to_node.each do |key,value|
      next if key == :type # Don't count "type" as an attribute
      attributes += "#{key.to_s}: '#{value}',"
    end
    attributes.chomp!(',') # Get rid of extra comma
    query += "{ #{attributes} }) "
    # The "a" and "b" nodes are now identified, so now create the relationship

    attributes = '' # Reset to process next MATCH statement
    query += "  CREATE (a) - [:#{rel_type[:type]} "
    rel_type.each do |key,value|
      next if key == :type # Don't count "type" as an attribute
      attributes += "#{key.to_s}: '#{value}',"
    end
    attributes.chomp!(',') # Get rid of extra comma
    query += "{ #{attributes} }] -> (b);"
    c = {
        "query" => "#{query}",
        "params" => {}
    }
    pp c
    RestClient.post @url, c.to_json, :content_type => :json, :accept => :json
  end


end

r = RGraph.new



r.create_node('server',
  { 'brand' => 'Supermicro',
    'type' => 'SM09443',
    'serial' => '1993830',
    'cpu' => 'Xenon 1990',
    'cpu_num' => '2',
    'ram' => '364',
    'desc' => 'Server'
  })
r.create_node('server',
  { 'brand' => 'Supermicro',
    'type' => 'SM09443',
    'serial' => '1993831',
    'cpu' => 'Xeon 1990',
    'cpu_num' => '2',
    'ram' => '364',
    'desc' => 'Server'
  })

r.create_node('networkcard',
  { 'mac_address' => '00:22:33:ff:cc:dd',
    'link_speed' => '10',
    'brand' => 'intel',
    'desc' => 'Networkcard'
  })


r.create_node('networkcard',
  { 'mac_address' => '00:22:33:ff:cc:ff',
    'link_speed' => '10',
    'brand' => 'intel',
    'desc' => 'Networkcard'
  })

r.create_node('networkcard',
  { 'mac_address' => '00:22:33:ff:cc:ee',
    'link_speed' => '10',
    'brand' => 'intel',
    'desc' => 'Networkcard'
  })

r.create_node('networkcard',
  { 'mac_address' => '00:22:33:ff:cc:aa',
    'link_speed' => '10',
    'brand' => 'intel',
    'desc' => 'Networkcard'
  })


r.create_node('switch',
  { 'brand' => 'hp',
    'type' => 'procurve 2910',
    'desc' => 'Switch'
  }
)

r.create_node('switch_port',
  {'mac' => 'aa:bb:cc:dd:ee:00',
   'link_speed' => '10G',
   'desc' => 'switch_port',
   'port_number' => '01'
  }
)

r.create_node('switch_port',
  {'mac' => 'aa:bb:cc:dd:ee:01',
   'link_speed' => '10G',
   'desc' => 'switch_port',
   'port_number' => '02'
  }
)

r.create_node('switch_port',
  {'mac' => 'aa:bb:cc:dd:ee:02',
   'link_speed' => '10G',
   'desc' => 'switch_port',
   'port_number' => '03'
  }
)

r.create_node('switch_port',
  {'mac' => 'aa:bb:cc:dd:ee:03',
   'link_speed' => '10G',
   'desc' => 'switch_port',
   'port_number' => '04'
  }
)

r.create_node('switch_port',
  {'mac' => 'aa:bb:cc:dd:ee:04',
   'link_speed' => '10G',
   'desc' => 'switch_port',
   'port_number' => '05'
  }
)

r.create_node('switch_port',
  {'mac' => 'aa:bb:cc:dd:ee:05',
   'link_speed' => '10G',
   'desc' => 'switch_port',
   'port_number' => '06'
  }
)

r.create_node('powersupply',
  {'watts' => '200W',
   'voltage' => '220V',
   'desc' => 'Powersupply',
   'serial' => '001920039'
  }
)

r.create_node('powersupply',
  {'watts' => '200W',
   'voltage' => '220V',
   'desc' => 'Powersupply',
   'serial' => '001920038'
  }
)

r.create_node('powersupply',
  {'watts' => '200W',
   'voltage' => '220V',
   'desc' => 'Powersupply',
   'serial' => '001920037'
  }
)

r.create_node('powersupply',
  {'watts' => '200W',
   'voltage' => '220V',
   'desc' => 'Powersupply',
   'serial' => '001920036'
  }
)

r.create_node('powerstrip',
  {'group' => '1',
   'phase' => '2',
   'desc' => 'Power Strip',
   'ampere' => '32A'
  }
)

r.create_node('powerstrip',
  {'group' => '2',
   'phase' => '3',
   'desc' => 'Power Strip',
   'ampere' => '32A'
  }
)

r.create_node('rack',
  {'U' => '32',
   'location' => 'D3',
   'desc' => 'Rack'
   }
)

r.create_node('application',
  {'name' => 'Openstack HyperVisor',
   'version' => 'Juno',
   'desc' => 'Openstack Hypervisor',
   'install_no' => '1'
   }
)

r.create_node('application',
  {'name' => 'Openstack HyperVisor',
   'version' => 'Juno',
   'desc' => 'Openstack Hypervisor',
   'install_no' => '2'
   }
)

r.create_node('cluster',
  {'name' => 'Openstack',
   'version' => 'Juno',
   'desc' => 'Openstack Cluster',
   'cluster_no' => '2'
   }
)




r.create_directed_relationship( {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:dd"},  {:type => 'server','serial'=> '1993830'}, {:type => 'physical','foo'=>'bar'})
r.create_directed_relationship( {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:aa"},  {:type => 'server','serial'=> '1993830'}, {:type => 'physical'})
r.create_directed_relationship( {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:ee"},  {:type => 'server','serial'=> '1993831'}, {:type => 'physical'})
r.create_directed_relationship( {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:ff"},  {:type => 'server','serial'=> '1993831'}, {:type => 'physical'},)

r.create_directed_relationship({:type => 'switch','type'=>"procurve 2910"}, {:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:00'}, {:type => 'physical'})
r.create_directed_relationship({:type => 'switch','type'=>"procurve 2910"}, {:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:01'}, {:type => 'physical'})
r.create_directed_relationship({:type => 'switch','type'=>"procurve 2910"}, {:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:02'}, {:type => 'physical'})
r.create_directed_relationship({:type => 'switch','type'=>"procurve 2910"}, {:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:03'}, {:type => 'physical'})
r.create_directed_relationship({:type => 'switch','type'=>"procurve 2910"}, {:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:04'}, {:type => 'physical'})
r.create_directed_relationship({:type => 'switch','type'=>"procurve 2910"}, {:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:05'}, {:type => 'physical'})

r.create_directed_relationship({:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:00'}, {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:dd"}, {:type => 'network_link','untagged'=>'60','tagged'=>'10,4'})
r.create_directed_relationship({:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:01'}, {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:aa"}, {:type => 'network_link','untagged'=>'40','tagged'=>'7'})
r.create_directed_relationship({:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:02'}, {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:ee"}, {:type => 'network_link','untagged'=>'60','tagged'=>'10,4'})
r.create_directed_relationship({:type => 'switch_port','mac'=> 'aa:bb:cc:dd:ee:03'}, {:type => 'networkcard','mac_address'=>"00:22:33:ff:cc:ff"}, {:type => 'network_link','untagged'=>'40','tagged'=>'7'})

r.create_directed_relationship( {:type => 'powersupply','serial'=>"001920036"},  {:type => 'server','serial'=> '1993830'}, {:type => 'physical'})
r.create_directed_relationship( {:type => 'powersupply','serial'=>"001920037"},  {:type => 'server','serial'=> '1993830'}, {:type => 'physical'})
r.create_directed_relationship( {:type => 'powersupply','serial'=>"001920038"},  {:type => 'server','serial'=> '1993831'}, {:type => 'physical'})
r.create_directed_relationship( {:type => 'powersupply','serial'=>"001920039"},  {:type => 'server','serial'=> '1993831'}, {:type => 'physical'})

r.create_directed_relationship( {:type => 'powerstrip','group'=>"1"},  {:type => 'powersupply','serial'=>"001920036"}, {:type => 'cable'})
r.create_directed_relationship( {:type => 'powerstrip','group'=>"2"},  {:type => 'powersupply','serial'=>"001920037"}, {:type => 'cable'})
r.create_directed_relationship( {:type => 'powerstrip','group'=>"1"},  {:type => 'powersupply','serial'=>"001920038"}, {:type => 'cable'})
r.create_directed_relationship( {:type => 'powerstrip','group'=>"2"},  {:type => 'powersupply','serial'=>"001920039"}, {:type => 'cable'})
r.create_directed_relationship({:type => 'powerstrip','group'=>"2"},{:type => 'switch','type'=>"procurve 2910"}, {:type => 'physical'})

r.create_directed_relationship({:type => 'server','serial'=>"1993830"},{:type => 'application','install_no'=>"1"}, {:type => 'software'})
r.create_directed_relationship({:type => 'server','serial'=>"1993831"},{:type => 'application','install_no'=>"2"}, {:type => 'software'})

r.create_directed_relationship({:type => 'application','name'=>"Openstack HyperVisor"},{:type => 'cluster','name'=>"Openstack"}, {:type => 'software'})

r.create_directed_relationship({:type => 'rack','location'=>"D3"},{:type => 'server','serial'=>"1993831"}, {:type => 'location'})
r.create_directed_relationship({:type => 'rack','location'=>"D3"},{:type => 'server','serial'=>"1993831"}, {:type => 'location'})
r.create_directed_relationship({:type => 'rack','location'=>"D3"},{:type => 'switch','type'=>"procurve 2910"}, {:type => 'location'})
r.create_directed_relationship({:type => 'rack','location'=>"D3"},{:type => 'powerstrip','group'=>"1"}, {:type => 'location'})
r.create_directed_relationship({:type => 'rack','location'=>"D3"},{:type => 'powerstrip','group'=>"2"}, {:type => 'location'})
