include_recipe "mercurial"
include_recipe "git"

# installs the demo app

python_pip "-r /srv/openblock/src/obdemo/requirements.txt -e /srv/openblock/src/obdemo" do
    virtualenv "/srv/openblock/virtualenv"

    action :install
end

template "/srv/openblock/src/obdemo/obdemo/settings.py" do
    source "settings.py.erb"

    owner "#{node[:user]}"
    variables({
        :db_user => node[:database][:user],
        :db_name => node[:database][:name]
    })
end