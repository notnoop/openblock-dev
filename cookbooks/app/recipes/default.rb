include_recipe "mercurial"
include_recipe "git"

# installs the demo app

python_pip "-r /srv/openblock/src/obdemo/requirements.txt" do
    virtualenv "/srv/openblock/virtualenv"

    action :install
end

python_pip "-e /srv/openblock/src/obdemo" do
    virtualenv "/srv/openblock/virtualenv"

    action :install
end

template "/srv/openblock/src/obdemo/obdemo/settings.py" do
    source "settings.py.erb"

    owner node[:user]
    mode 0755
    variables({
        :db_user => node[:database][:user],
        :db_name => node[:database][:name],
        :debug => node[:debug]
    })
end
