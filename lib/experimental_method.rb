#!/usr/bin/env ruby

class Module
  def experimental_method(method_name, &block)
    return if method_defined?(:"experimental_method_#{method_name}")
    alias_method :"experimental_method_#{method_name}", "#{method_name}"
    define_method method_name.to_sym do |*args, &spied_method_block|
      if "#{self.class.name}" == "Class"
        klass = "#{self.name}" 
        scope_separator = '.'
      else
        klass = "#{self.class.name}" 
        scope_separator = '#'
      end
      file = "/tmp/use_experimental_method_#{klass.downcase}_#{method_name}"
      puts "#{Time.now.to_i} Experimental: #{klass}#{scope_separator}#{method_name}(..) use #{file}"
      if File.exists?(file)
        return block.call(*args, &spied_method_block)
      end
      send(:"experimental_method_#{method_name}", *args, &spied_method_block)
    end
  end
end

