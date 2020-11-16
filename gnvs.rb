#!/usr/bin/ruby

$logs = "/var/log/nginx"
$database = "/var/lib/goaccess"
$output = "/var/www/goaccess"

require 'fileutils'

def sites()
  sites = []
  Dir.foreach($logs) do |log|
    if log =~ /^(.*)\.access\.log$/ then
      sites << $1
    end
  end
  sites
end

def generate_site(site)
  site_database = $database + "/" + site
  site_log = $logs + "/" + site + ".access.log"
  site_output = $output + "/" + site + ".html"
  FileUtils.mkdir_p $output
  FileUtils.mkdir_p site_database
  system("goaccess", "--log-format=COMBINED", site_log, "--output", site_output,
         "--db-path=#{site_database}", "--keep-db-files", "--load-from-disk",
         "--ignore-crawlers", "--agent-list")
end

def generate_page()
  open($output + "/index.html", "w") do |main|
    main.puts "<!DOCTYPE html>"
    main.puts "<html>"
    main.puts "  <head><title>web stats</title></head>"
    main.puts "  <body>"
    main.puts "    <ul>"
    sites().each do |site|
      generate_site(site)
      site_href = site + ".html"
      main.puts "      <li><a href=#{site_href}>#{site}</a></li>"
    end
    main.puts "    </ul>"
    main.puts "  </body>"
    main.puts "</html>"
  end
end

generate_page()

