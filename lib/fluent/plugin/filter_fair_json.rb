require 'json'
require 'fluent/filter'
require 'fluent/event'
require 'fluent/time'

module Fluent
  class FairJsonFilter < Filter
    Fluent::Plugin.register_filter('fair_json', self)

    desc 'The key name to parse as JSON'
    config_param :key_name, :string, default: 'log'
    desc 'If set to true does not raise an error when the key does not exist in the record'
    config_param :ignore_key_not_exist, :bool, default: false
    desc 'If set to true does not raise an error if the key fails to parse as json'
    config_param :ignore_parse_error, :bool, default: false
    desc 'Overwrites the time of events with a value of the key. Must be a unix time (optional float)'
    config_param :renew_time_key, :string, default: nil
    desc 'Store parsed values as a hash value in a field. Default is nil'
    config_param :hash_value_field, :string, default: nil

    def filter_with_time(tag, time, record)
      if record.has_key? @key_name
        begin
          parsed = JSON.parse(record[@key_name])

          # Insert parsed json into record
          record.delete(@key_name)
          if !@hash_value_field.nil?
            record[@hash_value_field] = parsed
          else
            record.merge!(parsed)
          end

          # Renew record time
          if !@renew_time_key.nil? and parsed.has_key? @renew_time_key
            time = Fluent::EventTime.from_time(Time.at(parsed[@renew_time_key].to_f))
          end

        rescue JSON::ParserError => e
          if !ignore_parse_error
            router.emit_error_event(tag, time, record, e)
          end
        end

      elsif !@ignore_key_not_exist
        router.emit_error_event(tag, time, record, ArgumentError.new("#{@key_name} does not exist"))
      end
      return time, record
    end
  end
end
