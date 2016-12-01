require_relative 'flypaper'

shake_runner = Flypaper.new

class Object
  def self.method_added(name)
  end
  def self.singleton_method_added(name)
  end
end

class TotallyUnrelated
  def lulz
  end
end

class Base
end

class Derp < Base
  def hello
    puts 'hello'
  end
  def self.class_meth
    puts 'classy'
  end
  def self.unused_class_meth
    puts 'WASTE IS NOT CLASSY'
  end
  def with_args(one, two)
    puts "#{one} #{two}"
  end
  define_method(:dynamic_method) do
    puts 'ok...'
  end
end

class Base::Shite
  def shite_base
  end
end

class Over < Derp
  def self.method_added(name)
    super
    # puts 'nothing really...'
  end

  def test_from_over
  end
end

Derp.class_meth
a = Derp.new
a.hello

shake_runner.print_unused

