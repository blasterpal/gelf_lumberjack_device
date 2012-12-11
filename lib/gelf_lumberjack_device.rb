require 'gelf'
require 'lumberjack'
require 'syslog'

module GELF


  # This Lumberjack device logs output to Graylog via UDP (using the gelf-rb library)
  class LumberjackDevice < Lumberjack::Device
    
    # based on extensive empirical testing this is mapping to Graylog2 v0.9.6. 
    SEVERITY_MAP = {
      Lumberjack::Severity::DEBUG => 0,
      Lumberjack::Severity::INFO => 1,
      Lumberjack::Severity::WARN => 3,
      Lumberjack::Severity::ERROR => 4,
      Lumberjack::Severity::FATAL => 5,
      Lumberjack::Severity::UNKNOWN => 6
    }

    # Create a new GELF::LumberjackDevice. The options control how messages are written to Graylog.
    # In order to connect to GELF you must supply connection options.
    # The host of the Graylog server <tt>:host</tt> 
    # The port of the Graylog server <tt>:port</tt> 
    # The facility/application name of the Graylog server <tt>:facility</tt> 
    # The max_size for GELF messages <tt>:max_size</tt> 
    # The template can be specified using the <tt>:template</tt> option. This can
    # either be a Proc or a string that will compile into a Template object.
    # If the template is a Proc, it should accept an LogEntry as its only argument and output a string.
    # If the template is a template string, it will be used to create a Template.
    # The default template is <tt>":message (#:unit_of_work_id)"</tt>.

    def initialize(options = {})
      @template = options[:template] || lambda{|entry| entry.unit_of_work_id ? "#{entry.message} (##{entry.unit_of_work_id})" : entry.message}
      @template = Template.new(@template) if @template.is_a?(String)
      @graylog_host = options[:host] || 'localhost'
      @graylog_port = options[:port] || 12201
      @graylog_facility = options[:facility] || 'gelf-lumberjack'
      @graylog_max_size = options[:max_size] || 'WAN' #WAN or LAN  
      @graylog_logger = GELF::Logger.new(@graylog_host,@graylog_port,@graylog_max_size,
        {'facility' => @graylog_facility, 'logging_exclusions' => options[:logging_exclusions]})
    end

    def write(entry)
      message = @template.call(entry)
      @graylog_logger.add(SEVERITY_MAP[entry.severity],message,@graylog_facility)
    end

    def flush
      #we're not buffering for now, if we do we'll need to implement a mutex as well
    end

    def close
      #GELF logger doesn't implement a close
    end

  end
end
