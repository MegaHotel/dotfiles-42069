function dfh --description "Show disk usage"
  df -h | grep '/$'
end
