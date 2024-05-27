function cdv --description "cd to a folder and open vim"
  cd $argv && \
  vim && \
  sleep 0.1 && \
  i3-msg '[class="^neovide$"] focus; [class="^neovide$"] move up; [class="^neovide$"] resize grow height 20 px or 20 ppt; [class="^neovide$"] fullscreen toggle;';
end
