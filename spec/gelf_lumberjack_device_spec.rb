require 'spec_helper'

describe GELF::LumberjackDevice do
  
  let(:time){ Time.parse("2011-02-01T18:32:31Z") }
  let(:entry){ Lumberjack::LogEntry.new(time, Lumberjack::Severity::WARN, "message 1", "lumberjack_graylog_device_spec", 12345, "ABCD") }
  let(:options){{:host => 'me.localhost', :port => 12202, :max_size => 'LAN', :facility => 'yourgreat_app'}}
  let(:gelf) { mock('GELF') }
  
  before do
    GELF::Logger.stub(:new).and_return(gelf)
  end

  context "logging" do  
    it "should calls graylog.add correctly" do
      device = GELF::LumberjackDevice.new(:options => options)
      gelf.should_receive(:add).with(3,"message 1 (#ABCD)","gelf-lumberjack")
      device.write(entry)
    end
  end

end
