module Nevermind
  class Proto
    def initialize(first, second)
      @first, @second = first, second
    end

    def where(*args)
      @first.where(*args)
      @second.where(*args)
    end

    def method_missing(method, *args, &block)
      if '!' == method.to_s.last
        forced_method_missing(method, *args, &block)
      else
        regular_method_missing(method, *args, &block)
      end
    end

    private
      # find_by, first, etc
      def regular_method_missing(method, *args, &block)
        found = @first.send method, *args, &block
        if found.nil?
          found = @second.send method, *args, &block
        end
        return found
      end

      # find_by!, first!, etc
      def forced_method_missing(method, *args, &block)
        begin
          found = @first.send method, *args, &block
        rescue
          found = @second.send method, *args, &block
        ensure
          return found
        end
      end
  end
end