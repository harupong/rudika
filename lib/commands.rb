#!/usr/bin/env ruby

def station
  ARGV.shift
end

def record
  unless ARGV.size == 1
    abort "ERROR: Only one station can be recorded at once. Aborting."
  end
  s = station
  case s
  when "NHK1" , "NHK2" , "FM"
    system ("ripdiru #{s}")
  else
    system ("ripdiko #{s}")
  end
end

def cron
  puts "this is schedule method"
end

def list
  puts "this is list method"
end
