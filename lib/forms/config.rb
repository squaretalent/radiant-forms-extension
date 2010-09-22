module Forms
  module Config
    
    class << self
      def convert(yaml)
        hash = hashify(yaml)
        hash = symbolize(hash)
        
        hash
      end
      
      def hashify(yaml)
        YAML::load("--- !map:HashWithIndifferentAccess\n"+yaml)
      end
      
      def symbolize(item)
        case item
        when Hash
          item.inject({}) do |acc, (k, v)|
            acc[(k.to_sym rescue k)] = symbolize v
            acc
          end
        when Array
          item.map { |i| symbolize i }
        else
          item
        end
        
        item
      end
    end
    
  end
end