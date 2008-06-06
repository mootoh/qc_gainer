#
#  Created by mootoh on 6/3/08.
#  Copyright (c) 2008 deadbeaf.org. All rights reserved.
#
require 'logger'
require 'osx/cocoa'
OSX.require_framework 'QuartzComposer'

class QCRubyPlugin < OSX::QCPlugIn
=begin
  def self.attributes

    {OSX::QCPlugInAttributeNameKey => "Example RubyPlugin",
     OSX::QCPlugInAttributeDescriptionKey => "by RubyCocoa."
    }
	
  end

  def self.attributesForPropertyPortWithKey(key)
  end
=end
	
  def self.executionMode
    2
  end

  def self.timeMode
    0
  end

  def initialize
    @logger = Logger.new('/tmp/qc_ruby_plugin.log')
    @logger.level = Logger::DEBUG
  end


  def startExecution(context)
	@logger.debug("startExecution")

    Thread.new {
      sleep 0.1
      5.times do |i|
        begin
          addInputPortWithType_forKey_withAttributes(OSX::QCPortTypeString, "input_" + i.to_s, nil)
          addOutputPortWithType_forKey_withAttributes(OSX::QCPortTypeString, "out_" + i.to_s, nil)
		  @logger.debug("ports added")
        rescue => e
          @logger.error(e.message)
        end
      end
    }
    true
  end

  def execute_atTime_withArguments(context, time, args)
	@logger.debug("execute !")
	begin
      @logger.debug(valueForInputKey("input_0"))
      setValue_forOutputKey(
		[valueForInputKey("input_0"), "Ruby", valueForInputKey("input_1")].join(' '),
		"out_0")
    rescue => e
      @logger.error(e.message)
    end

    true
  end

  def stopExecution(context)
	@logger.debug("stopExecution")
    true
  end
end
