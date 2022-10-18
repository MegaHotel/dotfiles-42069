function iplocation --description "Show geo details for IP address"
  curl https://ipinfo.io/$argv
end
