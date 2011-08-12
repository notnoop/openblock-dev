include_recipe "apache2"
include_recipe "apache2::mod_wsgi"

bash "create database www-user user" do
    user "postgres"

    code "createuser -s www-data"

    not_if (<<-EOH
    echo "select usename from pg_user where usename = 'www-data';" | psql | grep www-data
    EOH
    ), :user => "postgres"
end


template "/srv/openblock/app.wsgi" do
    source "app.wsgi"

    owner node[:user]
    mode 0755
end

bash "disable default apache" do
  user "root"

  code "a2dissite default"
end

bash "collect all files" do
    code <<-EOY
    DJANGO_SETTINGS_MODULE=obdemo.settings /srv/openblock/virtualenv/bin/django-admin.py collectstatic --noinput
    EOY

    user node[:user]
end

web_app "openblock"

