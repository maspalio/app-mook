#!/usr/bin/env ruby

Vagrant.configure("2") do |config|
  config.vm.box = "minimal/trusty64"

  config.vm.provider :virtualbox do |vb|
    vb.name   = "app-mook"
    vb.memory = 1024
    vb.cpus   = 1
  end

  config.vm.provider 'virtualbox' do |vb|
    vb.customize [ 'modifyvm', :id, '--cpuexecutioncap', 90 ]
  end

  config.vm.network :forwarded_port, guest: 5000, host: 5000, id: "http"

  [ "cpanminus", "sqlite3" ].each do |package|
    config.vm.provision "install-#{package}", type: "shell", privileged: true, inline: "apt-get install #{package} --yes"
  end

  config.vm.provision "app-clone", type: "shell", privileged: false, inline: "if [[ ! -d app-mook ]]; then git clone https://github.com/maspalio/app-mook.git; fi"

  [ "deps", "setup", "start", "status" ].each do |action|
    config.vm.provision "app-#{action}", type: "shell", privileged: false, inline: "./app-mook/bin/#{action}.sh"
  end
end
