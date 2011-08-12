maintainer        "Mahmood Ali"
maintainer_email  "cookbooks@notnoop.com"
license           "Apache 2.0"
description       "Installs the PostGis setup for PostgreSQL database"
version           "0.0.1"

depends           "postgresql"

recipe "postgis", "Installs postgis and postgis database template"

%w{ debian ubuntu }.each do |os|
  supports os
end

