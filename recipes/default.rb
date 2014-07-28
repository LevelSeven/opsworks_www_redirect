#
# Cookbook Name:: opsworks_www_redirect
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc.
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
include_recipe "passenger_apache2"

directory "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d" do
  action :create
  mode 0644
  owner 'root'
  group 'root'
end

template "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d/local-wwwredirect.conf" do
  Chef::Log.debug("Generating www redirect config file for #{application_name.inspect}")
  source 'local-wwwredirect.conf.erb'
  owner 'root'
  group 'root'
  mode 0644

  if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application_name}.conf") 
    notified :reload, "service[apache2]", :delayed
  end
end
