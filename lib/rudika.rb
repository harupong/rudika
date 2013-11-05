#!/usr/bin/env ruby

require "thor"
#require "./lib/commands"

class Rudika < Thor
  desc "rec", "rip and record the stream from Radiko/NHK"
  option :station, :required => true, :aliases => "-s"
    def rec
      station = options[:station]

      case station
      when "NHK1", "NHK2", "FM"
        system ("ripdiru #{station}")
      else
        system ("ripdiko #{station}")
      end
    end

  desc "list", "lists all available stations"
    def list
      puts "listing..."
    end

  desc "schedule", "schedules a recording"
    def schedule
      puts "scheduling..."
    end
end
