HOSTNAME=$(hostname)
length=$(echo -n "$HOSTNAME" | wc -c)

setopt PROMPT_SUBST
get_ip() {
  if [[ -n "$(ifconfig tun0 2>/dev/null)" ]]; then
    echo "%{$fg[green]%}$(ifconfig tun0 | awk '/inet / {print $2}')%{$reset_color%}"
  elif [[ -n "$(ifconfig wlan0 2>/dev/null)" ]]; then
    echo "%{$fg[green]%}$(ifconfig wlan0 | awk '/inet / {print $2}')%{$reset_color%}"
  else
    echo "%{$fg[red]%}No IP%{$reset_color%}"
  fi
}

shorten_path() {
  local path=$(pwd)
  local path_length=${#path}

  if (( path_length > 45 )); then
    echo "...${path: -40}" 
  else
    echo "$path"
  fi
}



if (( length < 15 )); then
  PROMPT=$'
┌─[%B%F{blue}'"${USER}"' '"${HOSTNAME}"'  $(shorten_path "$PWD")%f%b] [%F{green} $(get_ip)%f] $(git_prompt_info)
└─%B%F$%f%b '
else
  PROMPT=$'
┌─[%F{blue}'"${USER}"'  %~%f] [%F{green} $(get_ip)%f] $(git_prompt_info)
└─%B%F$%f%b '
fi

RPROMPT='%(?..'"${RED}Exit %?"')'
