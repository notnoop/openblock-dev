include_recipe "git"

execute "apt-get update" do
    action :run
end

package "build-essential"

%w{libxml2 libxml2-dev libxslt1.1 libxslt1-dev wget unzip}.each do |f|
    package f
end

package "libgdal1-dev"
package "libgdal1-1.6.0"

execute "ldconfig" do
    user "root"
    action :run
end

package "python-gdal"
package "python-lxml"


directory "/srv/openblock" do
    owner "#{node[:user]}"
end

python_virtualenv "/srv/openblock/virtualenv" do
    interpreter "python"

    owner "#{node[:user]}"
    #options "--no-site-packages"

    action :create
end

link "/srv/openblock/src" do
    to "#{node[:project_dir]}/openblock"
end

%w{ebpub ebdata obadmin}.each do |p|
    python_pip "-r /srv/openblock/src/#{p}/requirements.txt" do
        virtualenv "/srv/openblock/virtualenv"
        action :install
    end
    python_pip "-e /srv/openblock/src/#{p}" do
        virtualenv "/srv/openblock/virtualenv"
        action :install
    end
end

#python_pip "-r /srv/openblock/src/ebdata/requirements.txt" do
#    virtualenv "/srv/openblock/virtualenv"
#    action :install
#end
#
#python_pip "-r /srv/openblock/src/obadmin/requirements.txt" do
#    virtualenv "/srv/openblock/virtualenv"
#    action :install
#end
#
