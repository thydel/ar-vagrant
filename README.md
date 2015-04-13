<!--- -*- Mode: Markdown; fill-column: 96; -*- --->
<!--- Ansible managed: /home/thy/usr/thydel/ar-vagrant/setup/templates/README.md.j2 modified by thy on make.epiconcept.local --->

# Role Name

Install latest Vagrant

## Role Variables

```yaml
vagrant_baseurl: https://dl.bintray.com/mitchellh/vagrant
vagrant_debfile: vagrant_1.7.2_x86_64.deb
vagrant_debdir: /usr/local/deb
http_proxy: # use to set environment http_proxy, default(omit)
```

## Example Playbook

```yaml
- hosts: servers
  roles:
    - role: thydel.vagrant
```

## Usage

ansible-playbook -i localhost, vagrant-setup.yml --diff
ansible-playbook -i localhost, -c local vagrant-play.yml --check

## License

MIT

