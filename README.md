# Syncopated Linux

An exercise in configuration management for an audio production environment.


# Install

```bash
$ bash <(curl -s http://soundbot.hopto.org/bootstrap.sh)
```

[insert screencast]

# Usage

│ ansible-playbook -i inventory.yml ui.yml --limit soundbot,ninjabot --tags ui,home,i3                                                                                                                    │


│ ansible-playbook -i inventory.yml base.yml --limit soundbot,ninjabot --tags utils                                                                                                                       │


│ ansible-playbook -i inventory.yml base.yml --limit soundbot --tags autofs                                                                                                                               │

# About

```yaml
become = True
```

## PAQ { possibly asked questions }

> There are so many ways to go about doing all of this...you picked this one?

Sort of.
