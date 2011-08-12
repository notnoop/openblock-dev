OpenBlock Cookbooks
==========================================

This serves as a sample Chef deployment configuration to ease both development
and deployments of [OpenBlock](http://openblockproject.org) projects.  It uses
[Chef Solo](http://wiki.opscode.com/display/chef/Chef+Solo) for managing the
installation, and [Vagrant](http://vagrantup.com/) for preparing the virtual
development environment.

Customazations
-------------------------------

This project initializes the OpenBlock Demo project for Boston.  To customize
it, you may need to customize the following:

    * Adding a Git submodule (e.g. `openblock` here) pointing to the
      `OpenBlock` project to be deployed
    * Customizing `cookbooks/app/receipes/default.rb` to install any
      dependencies or configurations that is needed for the particular
      instance.  Please consult the `Chef` documentation.
    * Customize `cookbooks/app/templates/default/settings.py.erb` for the
      OpenBlock project.


Development
-------------------------------

This project uses [Vagrant](http://vagrantup.com/) to build a virtualized
environment for `OpenBlock` that closely resembles the production environment.
Running in a virtual mode reduces many of cross-compatibility concerns and
insulates the host server from being corrupted by dependencies.

Please note that you can still edit files in your favorite editor using your
favorite tools in the host system.  Any changes made to the files will be
immediately propograted to the virtual machine.

### Initial Installation

Follow the [Vagrant Get Started Guide](http://vagrantup.com/docs/getting-started/index.html)
to install [`VirtualBox`](www.virtualbox.org) and Vagrant.

Basically, once `VirtualBox` is installed, and already have RubyGems installed, you can run:

    $ gem install vagrant
    $ vagrant box add lucid32 http://files.vagrantup.com/lucid32.box

### Getting started

To bootstrap the full environment, you simple need to do the following:

    $ # Check out the code
    $ git clone git://github.com/notnoop/openblock-dev.git
    $ cd openblock-dev
    $ git submodule update

    $ vagrant up
    ...... Takes a while to setup the virtual environment and install .....
    ...... all dependencies .....

    $ vagrant ssh
    # The project is installed in `/srv/openblock/src` with scripts in
    # `/vagrant`

    (virtual)$ # Set up virtual environment and settings
    (virtual)$ source /vagrant/set_env

    (virtual)$ # Now run Django commands as usual
    (virtual)$ django-admin.py runserver 0.0.0.0:8000

In the browser go to [`http://localhost:9000`](http://localhost:9000) --
Please note the port being 9000, rather than 8000.

Please note that this sets up a project without any data.  Please follow the
OpenBlock instructions to initially seed the database.

Deployment
-------------------------------

**TODO**: Work in progress, recipes for nginx, apache, mod_python are needed.

This project also eases the deployment to deployment server (This only works
on Amazone Ubuntu AMI servers now).

### Initial Steps

All you need is an Ubuntu EC2 running an official
[Ubuntu AMI](http://cloud.ubuntu.com/ami/), like AMI-add819c4.  Go to
http://aws.amazon.com and setup an instance.

Setting up Amazon EC2 with the proper security groups and key pairs is
out-of-scope here (contributions are welcome!)

To ease development add the following to your `~/.ssh/config`:

    Host *.amazonaws.com
    User ubuntu
    IdentityFile ~/.ssh/amazonpair.pem

The `IdentityFile` should point to the SSH Key provided by Amazon, and
`HostName` is the public DNS provided by Amazon

### Getting started

Once you the machine is up, you can the following:

    $ export OB_HOST="ec2-174-129-76-100.compute-1.amazonaws.com"

    $ # Check out the code
    $ git clone git://github.com/notnoop/openblock-dev.git
    $ cd openblock-dev
    $ git submodule update

    $ # Deploy now!
    $ ./deploy.sh $OB_HOST

Now you can go to your browser and access
`http://ec2-50-16-113-38.compute-1.amazonaws.com/` to see the latest
installation.

You will still need to login to seed the data.  Doing so requires.

    $ ssh $OB_HOST
    $ source ./chef/set_env

    $ django-admin.py ... seed commands ...


TODO
------------------------------

  * Make the server version production quality (e.g. logrotate, nginx,
    caching headers, etc)
  * Check for proper file user permission, and allow having custom users (e.g.
    openblock)
  * Enable Static Files
