# Syncopated Linux

An exercise in configuration management for an audio production environment.


# Install

```bash
$ bash <(curl -s http://soundbot.hopto.org/bootstrap.sh)
```

[insert screencast]

# Usage


`ansible-playbook -i inventory.yml base.yml`

`ansible-playbook -i inventory.yml ui.yml --limit soundbot,ninjabot --tags i3`

`ansible-playbook -i inventory.yml ui.yml --limit soundbot,ninjabot --tags profile`

`ansible-playbook -i inventory.yml ui.yml --limit soundbot,ninjabot --tags shell`

`ansible-playbook -i inventory.yml ui.yml --limit soundbot,ninjabot --tags theme`

`ansible-playbook -i inventory.yml ui.yml --limit soundbot,ninjabot --tags home`

```bash
# to update mirrors
ansible-playbook -i inventory.yml base.yml --limit soundbot,ninjabot --tags repo,mirrors -e "update_mirrors=true"
```

```bash
# to setup an autofs client
ansible-playbook -i inventory.yml base.yml --limit soundbot --tags autofs
```

```bash
# preface tags with <skel> to make sure changes to files
# that reside /etc/skel have the correct permissions.
# e.g. to update profile configs: (which include shell, aliaeses and x configs)

ansible-playbook -i inventory.yml ui.yml --limit soundbot --tags skel,profile


available tags for ui: { profile, x, wm, shell, aliases, terminal, keybindings }
```

of course just running the ui playbook without specifiying tags is ok too.



# About

```yaml
become = True
```

## PAQ { possibly asked questions }

> There are so many ways to go about doing all of this...you picked this one?

Sort of.
