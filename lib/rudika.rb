#!/usr/bin/env ruby

require "thor"
require "./lib/stations"

class Rudika < Thor

  @@nhk_list = get_nhk_stations
  @@radiko_list = get_radiko_stations

  desc "rec", "rip and record the stream from Radiko/NHK"
  option :station, :required => true, :aliases => "-s"
  def rec
    nhk = @@nhk_list.keys
    radiko = @@radiko_list.keys
    station = options[:station]

    case station
    when *nhk
      system ("ripdiru #{station}")
    when *radiko
      system ("ripdiko #{station}")
    else
      puts "invalid station name. try `list` command."
    end
  end

  desc "list", "lists all available stations"
  def list
    all_stations = @@nhk_list.merge(@@radiko_list)

    all_stations.each.with_index(1) do |a, id|
      puts "#{id}: #{a}"
    end
  end

  desc "schedule", "schedules a recording"
    def schedule
      puts "scheduling..."
    end
end
