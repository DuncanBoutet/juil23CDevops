ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure("2") do |config|
  config.vm.define "HA1" do |admin|
    admin.vm.network :private_network, ip: "192.168.10.20", netmask: 24
    admin.vm.network "forwarded_port", guest: 80, host: 80
    admin.vm.network "forwarded_port", guest: 443, host: 443
    admin.vm.provider "docker" do |admin|
      admin.build_dir = "./HA/"
      admin.has_ssh = true
      admin.privileged = true
      admin.create_args = ["-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"]
      admin.name = "HA1"
    end
  end

  config.vm.define "database" do |database|
    database.vm.network :private_network, ip: "192.168.10.29", netmask: 24
    database.vm.network "forwarded_port", guest: 3306, host: 3306
    database.vm.provider "docker" do |database|
      database.build_dir = "./database/"
      database.has_ssh = true
      database.privileged = true
      database.create_args = ["-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"]
      database.name = "database"
    end
  end

  (1..2).each do |i|
    config.vm.define "client#{i}" do |client|
      client.vm.network "private_network", type: "static", ip: "192.168.10.2#{i}"
      client.vm.provider "docker" do |client|
        client.build_dir = "./client/"
        client.has_ssh = true
        client.privileged = true
        client.create_args = ["-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"]
        client.name = "client#{i}"
      end
    end
  end
end
