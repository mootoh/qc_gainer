#
#  Created by mootoh on 6/3/08.
#  Copyright (c) 2008 deadbeaf.org. All rights reserved.
#
require 'osx/cocoa'
OSX.require_framework 'QuartzComposer'
require 'funnel'

class QCGainer < OSX::QCPlugIn
  def self.executionMode
    2
  end

  def self.timeMode
    1
  end

  def initialize
    @initialized = false
    @gio = Funnel::Gainer.new(Funnel::Gainer::MODE1)

    @ain = [0,0,0,0]
    @din = [0,0,0,0]
    @aot = [0,0,0,0]
    @dot = [0,0,0,0]
  end

  def startExecution(context)
    Thread.new do
      sleep 0.1
      4.times { |i| addInputPortWithType_forKey_withAttributes(OSX::QCPortTypeNumber, "aot_" + i.to_s, nil)  }
      4.times { |i| addInputPortWithType_forKey_withAttributes(OSX::QCPortTypeNumber, "dot_" + i.to_s, nil)  }
      4.times { |i| addOutputPortWithType_forKey_withAttributes(OSX::QCPortTypeNumber, "ain_" + i.to_s, nil) }
      4.times { |i| addOutputPortWithType_forKey_withAttributes(OSX::QCPortTypeNumber, "din_" + i.to_s, nil) }
    end
    true
  end

  def execute_atTime_withArguments(context, time, args)
    unless @initialized
      @gio.ain(0).on Funnel::PortEvent::CHANGE do |event|
        @ain[0] = event.target.value
      end
      @initialized = false
    end

    4.times do |i|
      self.setValue_forOutputKey(@ain[i], "ain_" + i.to_s)
      self.setValue_forOutputKey(@din[i], "din_" + i.to_s)
    end

    true
  end

  def stopExecution(context)
    true
  end
end
