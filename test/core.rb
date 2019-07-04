require 'experimental_method'

class Test

  def my_instance_method(arg1, &block)
    x = "deprecated version received(#{arg1})"
    block.call(x) if block
  end

  experimental_method(:my_instance_method) do |args, &block|
    x = "experimental method received(#{args})" 
    block.call(x) if block
  end

  def my_instance_method_2(a, b, c)
    puts "#{a}, #{b}, #{c}"
  end

  experimental_method(:my_instance_method_2) do |a, b, c, &block|
    puts "#{a}, #{b}, #{c}"
  end

  def my_instance_method_3
    5
  end

  experimental_method(:my_instance_method_3) do
    puts "#{a}, #{b}, #{c}"
  end

  class << self

    def my_class_method(arg1, &block)
      x = "deprecated version received(#{arg1})"
      block.call(x) if block
    end

    experimental_method(:my_class_method) do |args, &block|
      x = "experimental method received(#{args})"
      block.call(x) if block
    end


  end

end

puts ''
puts '-------'
Test.new.my_instance_method(1)

puts ''
puts '-------'
Test.new.my_instance_method_2(1, 2, 3)

puts ''
puts '-------'
rase 'no 5' unless Test.new.my_instance_method_3 == 5

puts ''
puts '-------'
Test.new.my_instance_method(1) do |x|
  puts "instance method block says x = #{x}"
end

puts ''
puts '-------'
Test.my_class_method(1)

puts ''
puts '-------'
Test.my_class_method(1) do |x|
  puts "class method block says x = #{x}"
end

