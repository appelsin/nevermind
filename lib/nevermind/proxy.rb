module Nevermind
  class Proxy
    def initialize(first, second)
      @first, @second = first, second
    end

    def method_missing(method, *args, &block)
      if [:all, :where].include? method
        call_relation_method(method, *args, &block)
      else
        if '!' == method.to_s.last
          call_forced_method(method, *args, &block)
        else
          call_regular_method(method, *args, &block)
        end
      end
    end

    private
      # find_by, first, etc
      def call_regular_method(method, *args, &block)
        found = @first.send method, *args, &block
        if found.nil?
          found = @second.send method, *args, &block
        end
        return found
      end

      # find_by!, first!, etc
      def call_forced_method(method, *args, &block)
        begin
          found = @first.send method, *args, &block
        rescue
          found = @second.send method, *args, &block
        ensure
          return found
        end
      end

      def call_relation_method(method, *args, &block)
        Proxy.new @first.send(method, *args, &block),
                  @second.send(method, *args, &block)
      end
  end
end