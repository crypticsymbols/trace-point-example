class Flypaper

  def initialize
    @map = {}
    setup_tracer
  end

  def add_entry(object_name, method_name, file, line)
    map_key = make_key(object_name, method_name)
    map_entry = "#{file}:#{line}"
    @map[map_key] = map_entry
  end

  def remove_entry(object_name, method_name)
    map_key = make_key(object_name, method_name)
    p "Calling #{map_key} from #{}, removing from map."
    @map.delete(map_key)
  end

  def print_unused
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts ''
    puts "Done! #{@map.length} unused methods found."
    puts ''
    @map.each do | key, value |
      puts "Unused method found: #{key} in #{value}"
    end
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  end

  def cleanup
    @tracer.disable
  end

  private

  def make_key(object_name, method_name)
    # Do this... idk, better
    object_name.gsub!(/\d/, '')
    "#{object_name}##{method_name}".to_sym
  end

  def setup_tracer
    @tracer = TracePoint.new do | tp |
      if tp.event === :call && (tp.method_id === :method_added || tp.method_id === :singleton_method_added)
        meth = tp.binding
        p meth.eval('name')
        definer_class = meth.receiver.to_s
        defined_method_name = meth.eval('name')
        add_entry(definer_class, defined_method_name, tp.path, tp.lineno)
      elsif tp.event === :call && tp.binding && tp.binding.respond_to?(:receiver)
        object_name = tp.binding.receiver.to_s
        method_name = tp.method_id
        remove_entry(object_name, method_name)
      end
    end
    @tracer.enable
  end
end
