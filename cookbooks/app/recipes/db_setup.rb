# create super user

db_user = node[:database][:user]
db_name = node[:database][:name]

bash "create database user" do
    user "postgres"

    code "createuser -s #{db_user}"

    not_if (<<-EOH
    echo "select usename from pg_user where usename = '#{db_user}';" | psql | grep #{db_user}
    EOH
    ), :user => "postgres"
end

# prepare database
bash "create project database" do
    user "postgres"

    code "createdb -T template_postgis #{db_name}"

    not_if (<<-EOH
    echo "select datname from pg_database where datname='#{db_name}';" | psql | grep #{db_name}
    EOH
   ), :user => "postgres"
end

bash "Create db" do
    user "#{node[:user]}"

    code <<-EOY
    export DJANGO_SETTINGS_MODULE=obdemo.settings
    /srv/openblock/virtualenv/bin/django-admin.py syncdb --noinput --migrate
    EOY
end

