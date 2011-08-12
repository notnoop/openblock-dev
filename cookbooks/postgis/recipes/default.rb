
include_recipe "postgresql"
include_recipe "postgresql::server"

package "binutils"
package "gdal-bin"

package "postgresql-#{node.postgresql.version}-postgis"
package "postgresql-server-dev-#{node.postgresql.version}"

bash "Creating db template" do
    user "postgres"

    code IO.read(File.join(File.dirname(__FILE__), '..', 'files', 'create_template_postgis-debian.sh'))
end
