function cd --description "cd and exa"
  builtin cd $argv && \
  exa --long -a --icons;
end
