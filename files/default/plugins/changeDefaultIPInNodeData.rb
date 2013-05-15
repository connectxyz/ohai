network['interfaces'].each do |iface, addrs|
	if iface.eql?('eth0')
		addrs['addresses'].each do |ip, params|	
			self.ipaddress ip if params['family'].eql?('inet')
		end
  	end
end
