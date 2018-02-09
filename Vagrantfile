Vagrant.configure("2") do |c|
  # c.berkshelf.enabled = true if Vagrant.has_plugin?("vagrant-berkshelf")
  # c.berkshelf.berksfile_path = "Berksfile"

  c.vm.define "centos-6.6" do |cent66|
    cent66.vm.box = "bento/centos-6.6"
    cent66.vm.hostname = "default-centos-66"
  end
  
  c.vm.define "centos-7.2" do |cent72|
    cent72.vm.box = "bento/centos-7.2"
    cent72.vm.hostname = "default-centos-72"
  end

  c.vm.define "ubuntu-16.04" do |ub1604|
    ub1604.vm.box = "bento/ubuntu-16.04"
    ub1604.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-16.04_chef-provisionerless.box"
    ub1604.vm.hostname = "default-ubuntu-1604"
  end

  c.vm.synced_folder ".", "/vagrant", disabled: false

  ## For masterless, mount your salt file root
  c.vm.synced_folder "salt/", "/srv/salt/"

  ## Use all the defaults:
  c.vm.provision :salt do |salt|

    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end

end
