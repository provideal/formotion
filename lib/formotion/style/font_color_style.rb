module Formotion
  module RowStyle
    class FontColorStyle < Base
      PROPERTIES = [:color, :title, :subtitle, :value].each { |prop|
        attr_accessor prop
      }

      def self.default_object_key
        :color
      end

      def setup_cell(cell)
        if self.color
          cell.subviews_recursive_each do |subview|
            if subview.respond_to? "setTextColor:"
              subview.setTextColor(self.color.to_color)
            end
          end
        end

        if self.title
          cell.textLabel.setTextColor(self.title.to_color)
        end

        if self.subtitle
          cell.detailTextLabel.setTextColor(self.subtitle.to_color)
        end

        if self.value
          self.row.text_field.setTextColor(self.value.to_color)
        end
      end
    end
  end
end