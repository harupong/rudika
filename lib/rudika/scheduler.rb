#!/usr/bin/env ruby

require 'date'
require 'yaml'

module Rudika
  class Scheduler

    attr_reader :schedules

    def initialize(schedules)
      @schedules = schedules || []
    end

    def ask(question)
      print question
      STDIN.gets.chomp
    end

    def station_exists?(station)
      exist_stations = NHK_LIST.keys + RADIKO_LIST.keys
      exist_stations.include?(station)
    end

    def add_schedule
      schedule = {"station" => ask("Enter the station:")}
      unless station_exists?(schedule["station"])
        abort ("invalid station name. aborted. try `list` command.")
      end

      schedule = {
        "frequency" => ask("Enter the frequency. Daily, Weekly, Monthly[D,W,M]:")
      }
      unless schedule["frequency"].match(/[DdWwMm]/)
        abort ("invalid frequency. aborted. it must be D, W, or M.")
      end

      schedule = {"inputtime" => ask("Enter the date[YYYY-MM-DD hh:mm]:")}
      begin
        DateTime.parse(schedule["inputtime"])
      rescue ArgumentError
        abort ("invalid date format. aborted.")
      end

      add(schedule)
      update_whenever
    end

    def delete_schedule
      unless @schedules.empty?
        @schedules.each.with_index do |s, i|
          puts "#{i}: #{s}"
        end
        id = ask("Select the schedule you want to delete:")
        delete(id.to_i)
        update_whenever
      else
        abort "No schedule to delete."
      end
    end

    def show_schedule
      unless schedules # YAML is returning false if file is empty
        abort "No Schedule for rudika."
      end
      puts "Your schedules for rudika:"
      schedules.each.with_index do |s, id|
        station = s["station"]
        d = DateTime.parse("#{s["inputtime"]}+0900")
        date = d.strftime('%Y-%m-%d')
        t = d.strftime('%H:%M')
        freq = case s["frequency"]
               when "D"
                 "Daily at #{t}"
               when "W"
                 dayname = Date::DAYNAMES[d.wday]
                 "Weekly on #{dayname} at #{t}"
               when "M"
                 "Monthly on #{d.day} at #{t}"
               end
        puts "#{id}: #{station}, #{freq}"
      end
    end

    def update_whenever
      overwrite_yaml
      overwrite_whenever_config
      system("whenever -i")
    end

    def add(schedule)
      @schedules.push(schedule)
    end

    def delete(pos)
      @schedules.delete_at(pos)
    end

    def overwrite_yaml
      open("config/rudika.yaml", "w+") do |file|
        YAML.dump(@schedules, file)
      end
    end

    def overwrite_whenever_config
      template = <<EOS
  # Use this file to easily define all of your cron jobs.
  # Learn more: http://github.com/javan/whenever
  # uncomment the line below if you wish to use zsh for cron jobs for rudika
  # set :job_template, "/usr/bin/zsh -l -c ':job'"

  job_type :record, 'cd :path && bundle exec rudika rec -s :task'
EOS

      str = "\n"
      @schedules.each do |s|
        formatedtime = DateTime.parse(s["inputtime"])
        starttime = "#{formatedtime.hour}:#{formatedtime.minute}"
        dayname = Date::DAYNAMES[formatedtime.wday]
        monthname = Date::MONTHNAMES[formatedtime.month]
        dayofmonth = formatedtime.day
        station = s["station"]

        case s["frequency"]
        when "D"
          str.concat("every 1.day, :at => '#{starttime}' do record \"#{station}\" end\n")
        when "W"
          str.concat("every :#{dayname}, :at => '#{starttime}' do record \"#{station}\" end\n")
        when "M"
        # must pass monthname to :at symbol so that `whenever` can parse it correctly
        # https://github.com/javan/whenever/issues/13#issuecomment-18869
          str.concat(
            "every 1.month, :at => '#{monthname} #{dayofmonth} #{starttime}' do record \"#{station}\" end\n"
          )
        end
      end

      whenever_schedule = template.concat(str)
      open("config/schedule.rb", "w+") do |file|
        file.write(whenever_schedule)
      end
    end
  end
end
