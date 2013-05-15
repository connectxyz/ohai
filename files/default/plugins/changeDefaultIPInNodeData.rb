provides "network"
require_plugin "hostname"
require_plugin "#{os}::network"

network['interfaces'].each do |iface, addrs|
	if iface.eql?(node['network_interfaces']['private'])
		addrs['addresses'].each do |ip, params|	
			self.ipaddress ip if params['family'].eql?('inet')
			#network["ipaddress_#{iface}"] = ip if params['family'].eql?('inet')
			#network["ipaddress6_#{iface}"] = ip if params['family'].eql?('inet6')
			#network["macaddress_#{iface}"] = ip if params['family'].eql?('lladdr')
			#realip = ip if params['family'].eql?('inet') and iface.eql?(network_interfaces['private'])
		end
  	end
end
network
