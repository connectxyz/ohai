#
# Cookbook Name:: ohai
# Recipe:: default
#
# Copyright 2011, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#11:57 < paigeat> in a recipe, is there a way to get a quick file list of all the templates in the templates/default directory? 
#11:58 <@coderanger> paigeat: No
#11:58 <@coderanger> paigeat: They are only transferred on-demand, so they don't exist until requested

# so basically in addition to putting the plugin template into the templates/default directory you'll 
# need to specify "enable" it in some node attributes so it knows what file to fetch:
node['ohai']['templated_plugins'].each do |tPlugin|
	template node['ohai']['plugin_path'] + tPlugin do
		source tPlugin + '.erb'
	end
end
# node['ohai']['templated_plugins'][0] == 'changeDefaultIPInNodeData.rb' 
# and the file in templates/default would need to be named 'changeDefaultIPInNodeData.rb.erb'

unless Ohai::Config[:plugin_path].include?(node['ohai']['plugin_path'])
  Ohai::Config[:plugin_path] << node['ohai']['plugin_path']
end
Chef::Log.info("ohai plugins will be at: #{node['ohai']['plugin_path']}")

# This is done during the compile phase so new plugins can be used in
# resources later in the run.
reload_ohai = false
node['ohai']['plugins'].each_pair do |source_cookbook, path|

  rd = remote_directory node['ohai']['plugin_path'] do
    cookbook source_cookbook
    source path
    mode '0755' unless platform_family?('windows')
    recursive true
    purge false
    action :nothing
  end

  rd.run_action(:create)
  reload_ohai ||= rd.updated?

end

resource = ohai 'custom_plugins' do
  action :nothing
end

# only reload ohai if new plugins were dropped off OR
# node['ohai']['plugin_path'] does not exists in client.rb
if reload_ohai ||
  !(::IO.read(Chef::Config[:config_file]) =~ /Ohai::Config\[:plugin_path\]\s*<<\s*["']#{node['ohai']['plugin_path']}["']/)

  resource.run_action(:reload)
end
