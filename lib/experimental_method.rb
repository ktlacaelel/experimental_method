#!/usr/bin/env ruby

require 'fileutils'

class Module
  def experimental_method(method_name, &block)
    return if method_defined?(:"experimental_method_#{method_name}")
    alias_method :"experimental_method_#{method_name}", "#{method_name}"
    define_method method_name.to_sym do |*args, &spied_method_block|
      static = self.is_a?(Class)
      klass = "#{static ? self : self.class}"
      file = "/tmp/use_experimental_method_#{klass.downcase}_#{method_name}"
      efile = "#{file}.error"
      file_exists = File.exists?(file)
      version = file_exists ? 'experimental' : 'original'
      scope = static ? 'static' : 'instance'
      program = 'Experimental Method'
      timestamp = Time.now.to_i
      template = '%s [%s] %s is using (%s code) in %s method [%s] switch: %s'
      bindings = [timestamp, program, klass, version, scope, method_name, file]
      puts template % bindings
      begin
        return instance_eval(&block) if file_exists
      rescue => error
        FileUtils.mv(file, efile)
        File.open(efile, 'w+') do |file|
          file.puts error.message
          error.backtrace.each do |line|
            file.puts line
          end
        end
      end
      send(:"experimental_method_#{method_name}", *args, &spied_method_block)
    end
  end
end
