function weather --description "Show the weather for a given city"
  curl "https://wttr.in/$argv?m"
end
