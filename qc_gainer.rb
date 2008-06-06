#
#  Created by mootoh on 6/3/08.
#  Copyright (c) 2008 deadbeaf.org. All rights reserved.
#
require 'logger'
require 'osx/cocoa'
OSX.require_framework 'QuartzComposer'
require 'funnel'

class QCGainer < OSX::QCPlugIn
  def self.executionMode
    2
  end

  def self.timeMode
    0
  end

  def initialize
    @logger = Logger.new('/tmp/qc_ruby_plugin.log')
    @logger.level = Logger::DEBUG
    @yet = true
    @gio = Funnel::Gainer.new(Funnel::Gainer::MODE1)
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

    if @yet
      @gio.ain(0).on Funnel::PortEvent::CHANGE do |event|
        setValue_forOutputKey(event.target.value, "out_0")
      end
      @yet = false
    end

    true
  end

  def stopExecution(context)
    @logger.debug("stopExecution")
    true
  end
end
