import os
from xonsh.xontribs import xontribs_load
from pathlib import Path
from xonsh.built_ins import XSH
import subprocess

local_bin = os.path.expanduser("~/.local/bin")
fly_dir = os.path.expanduser("~/.fly/bin")
composer_dir = os.path.expanduser("~/.config/composer/vendor/bin")

env = __xonsh__.env

alias = __xonsh__.aliases

paths: list[str] = ["~/.local/bin", "~/.fly/bin", "~/.config/composer/vendor/bin"]

for path in paths:
    expanded_path = os.path.expanduser(path)
    if expanded_path not in env["PATH"]:
        env["PATH"].append(expanded_path)

xontribs_load(['prompt_starship'])

### Set Editor ###
env["EDITOR"] = "hx"

### SET FZF DEFAULTS
#env['FZF_DEFAULT_OPTS'] = "--layout=reverse --exact --border=bold --border=rounded --margin=3%  --color=dark"
env['FZF_DEFAULT_COMMAND'] = "fdfind --type f --hidden --follow"


eza_base = 'eza --color=always --group-directories-first'
# aliases
alias["ff"] = "fastfetch"
alias[".."] = "cd .."
alias['ls'] = f'{eza_base} -al'
alias['la'] = f'{eza_base} -a'
alias['ll'] = f'{eza_base} -l'
alias['lt'] = f'{eza_base} -aT'


ctx = XSH.ctx
mise_init = subprocess.run([Path('~/.local/bin/mise').expanduser(),'activate','xonsh'],capture_output=True,encoding="UTF-8").stdout
XSH.builtins.execx(mise_init,'exec',ctx,filename='mise')
