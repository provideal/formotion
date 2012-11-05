module Formotion
  module RowStyle
    class SelectionColorStyle < Base
      PROPERTIES = [:color, :top, :bottom, :font_color].each { |prop|
        attr_accessor prop
      }

      def self.default_object_key
        :color
      end

      def setup_cell(cell)
        if ["none", "blue", "gray"].member? self.color
          cell.selectionStyle = const_int_get("UITableViewCellSelectionStyle", self.color)
        else
          GradientBackgroundView.attach_to_cell(cell, as: "selectedBackgroundView")

          top_color = nil
          bottom_color = nil
          if self.color
            # use color + darker color
            top_color = self.color.to_color
            bottom_color = top_color.darkerColor
          else
            top_color = self.top.to_color
            bottom_color = self.bottom.to_color
          end

          cell.selectedBackgroundView.colors = [top_color, bottom_color]
        end

        if self.font_color
          cell.subviews_recursive_each do |subview|
            if subview.respond_to?("setHighlightedTextColor:")
              using_color = (self.font_color == "none") ? subview.textColor : self.font_color.to_color
              subview.setHighlightedTextColor(using_color)
            end
          end
        end
      end

      def will_display(cell)
        if self.tableView.grouped?
          cell.setPosition(self.row.position_type)
        end
      end

    end
  end
end