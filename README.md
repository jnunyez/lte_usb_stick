# lte_usb_stick

provisioning of vm associated to the execution of a UE using vagrant and virtualbox (to be replaced by kvm)

### vm preparation

avoid updates of boxes

```
config.vm.box_check_update=false
```

blacklist cdc_ether driver on host machine

using /etc/modprobe.d/blacklist-modem.conf

```
blacklist cdc_ether
```

### vagrant file config

Resources associated to VM
```
vb.cpus = 1
vb.memory = 1024

```

Forward usb detection from the host to the VM 

```
vb.customize ['modifyvm', :id, '--usb', 'on']
vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'HUAWEI_MOBILE', '--vendorid', '0x12d1']
```

Provisioning using Ansible and Vagrant shell

```
config.vm.provision "ansible" do |ansible|
ansible.playbook="provisioning/playbook.yml"
ansible.extra_vars = {
  ansible_python_interpreter: "/usr/bin/python3.6"
}
config.vm.provision "shell",
  run: "always",
   path: "./provisioning/provisioners.sh"
 end
```
