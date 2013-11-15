#!/usr/bin/env ruby

require 'thor'
require 'date'
require 'yaml'

file = open("config/stations.yaml")
NHK_LIST, RADIKO_LIST = YAML.load_stream(file)
file.close

module Rudika
  class CLI < Thor

    def initialize(args = [], options = {}, config = {})
      super
    end

    desc "rec", "rip and record the stream from Radiko/NHK"
    option :station, :required => true, :aliases => "-s"
    def rec
      nhk = NHK_LIST.keys
      radiko = RADIKO_LIST.keys
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
      all_stations = NHK_LIST.merge(RADIKO_LIST)

      all_stations.each.with_index(1) do |a, id|
        puts "#{id}: #{a}"
      end
    end

    desc "schedule", "schedules a recording"
    option :add, :type => :boolean, :aliases => "-a"
    option :delete, :type => :boolean, :aliases => "-d"
    option :show, :type => :boolean, :default => true, :aliases => "-s"
    def schedule
      schedules = open("config/rudika.yaml") do |file|
        YAML.load(file)
      end

      scheduler = Scheduler.new(schedules)

      case
      when options[:add]
        scheduler.add_schedule
      when options[:delete]
        scheduler.delete_schedule
      when options[:show]
        system ("whenever -f")
      end
    end

    desc "version", "shows version info"
    option :aliases => "-v"
    def version
      puts "Rudika Ver. #{Rudika::VERSION}"
    end
  end
end
