network['interfaces'].each do |iface, addrs|
	if iface.eql?('eth0')
		addrs['addresses'].each do |ip, params|	
			self.ipaddress ip if params['family'].eql?('inet')
			#network["ipaddress_#{iface}"] = ip if params['family'].eql?('inet')
			#network["ipaddress6_#{iface}"] = ip if params['family'].eql?('inet6')
			#network["macaddress_#{iface}"] = ip if params['family'].eql?('lladdr')
			#realip = ip if params['family'].eql?('inet') and iface.eql?(network_interfaces['private'])
		end
  	end
end
