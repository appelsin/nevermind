module Nevermind
  class Proxy
    # include Enumerable

    def initialize(first, second)
      @first, @second = first, second

      @order_params = nil
      @limit_params = nil
      @offset_params = nil
    end

    def each(&block)
      if @order_params || @limit_params || @offset_params
        get_scoped &block
      else
        @first.each { |obj| yield obj }
        @second.each { |obj| yield obj }
      end
    end

    def [](index)
      #todo: optimize!
      count = 0
      self.each do |obj|
        return obj if count == index
        count+= 1
      end
      return nil
    end

    def count
      if @order_params || @limit_params || @offset_params
        count = 0
        get_scoped { |val| count+= 1 }
        return count
      else
        @first.count + @second.count
      end
    end

    def order(*args)
      @order_params = *args
      return self.clone
    end

    def limit(*args)
      @limit_params = *args
      return self.clone
    end

    def offset(*args)
      @offset_params = *args
      return self.clone
    end

    def method_missing(method, *args, &block)
      if [:all, :where, :order].include? method
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

      # yields scoped result
      def get_scoped(&block)
        # can be used only with ActiveRecord
        #todo: implement Mongoid
        unless defined?(ActiveRecord::Relation) && @first.is_a?(ActiveRecord::Relation) && @second.is_a?(ActiveRecord::Relation)
          raise "#{ self.class }.#{ __method__ } not implemented for #{ @first.class } && #{ @second.class } yet. Only ActiveRecord::Relation i supported"
        end

        get_scoped_active_record &block
      end

      def get_scoped_active_record(&block)
        # get records ids in the desired scope
        # prepare sql
        #todo: protect from sql injection
        tables = {@first.table_name => @first,
                  @second.table_name => @second}

        order_by = @order_params.map do |param|
          if param.is_a? Hash
            "#{ param.first[0] } #{ param.first[1].upcase }"
          elsif param.is_a? String
            param
          elsif param.is_a? Symbol
            param.to_s
          end
        end.join(', ')

        columns = (['id'] +
            @order_params.map do |param|
              if param.is_a? Hash
                param.first[0].to_s
              elsif param.is_a? String
                param
              elsif param.is_a? Symbol
                param.to_s
              end
            end
        ).join(', ')

        sql = "SELECT #{ columns }, '#{ tables.keys[0] }' as table_name FROM #{ tables.keys[0] } as `a`" +
            ' UNION' +
            " SELECT #{ columns }, '#{ tables.keys[1] }' as table_name FROM #{ tables.keys[1] } as `b`" +
            (order_by == '' ? '' : " ORDER BY #{ order_by }") +
            if @limit_params.nil?
              ''
            else
              " LIMIT #{ @offset_params.nil? ? '' : "#{ @offset_params[0].to_s }, " }#{ @limit_params[0].to_s }"
            end

        # execute prepared sql
        records_array = ActiveRecord::Base.connection.execute(sql)

        # get records in the desired scope
        records_array.each do |r|
          yield tables[r['table_name']].find(r['id'])
        end
      end
  end
end