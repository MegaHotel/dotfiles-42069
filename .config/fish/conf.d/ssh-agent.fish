if status is-login
  eval (ssh-agent -c) 1> /dev/null
  ssh-add ~/.ssh/* 2> /dev/null
end
