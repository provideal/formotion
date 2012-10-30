module Formotion
  module RowStyle
    class Base
      attr_accessor :row, :tableView

      attr_accessor :default

      PROPERTIES = []

      def initialize(params)
        if !params.is_a?(Hash)
          params = { self.class.default_object_key => params }
        end

        params.each { |key, value|
          if self.class.const_get(:PROPERTIES).member? key.to_sym
            self.send("#{key}=".to_sym, value)
          end
        }
      end

      def tableView
        self.row.form.table
      end

      # called the first time the cell is created
      def setup_cell(cell)
      end

      # called every time the cell enters the screen
      def will_display(cell)
      end
    end
  end
end