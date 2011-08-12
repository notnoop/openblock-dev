
username = node[:user]

user "#{username}" do
    action :create
    home "/home/#{username}"
end
