module Forms
  module Config
    
    class << self
      def convert(yaml)
        hash = hashify(yaml)
        hash = deep_symbolize_keys(hash)
        
        hash
      end
      
      def hashify(yaml)
        YAML::load("--- !map:HashWithIndifferentAccess\n"+yaml)
      end
      
      def deep_symbolize_keys(item)
        case item
        when Hash
          item.inject({}) do |acc, (k, v)|
            acc[(k.to_sym rescue k)] = deep_symbolize_keys(v)
            acc
          end
        when Array
          item.map { |i| symbolize i }
        else
          item
        end
      end
    end
    
  end
end