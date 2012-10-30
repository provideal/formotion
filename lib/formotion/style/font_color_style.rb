module Formotion
  module RowStyle
    class FontColorStyle < Base
      PROPERTIES = [:color].each { |prop|
        attr_accessor prop
      }

      def self.default_object_key
        :color
      end

      def setup_cell(cell)
        cell.subviews_recursive_each do |subview|
          if subview.respond_to? "setTextColor:"
            subview.setTextColor(self.color.to_color)
          end
        end
      end
    end
  end
end