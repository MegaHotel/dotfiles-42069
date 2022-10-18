function cd --description "Add exa to the cd command"
  builtin cd $argv && \
  exa --long -a --icons;
end

