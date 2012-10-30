module Formotion
  module RowStyle
    class BackgroundColorStyle < Base
      PROPERTIES = [:color, :top, :bottom].each { |prop|
        attr_accessor prop
      }

      def self.default_object_key
        :color
      end

      def setup_cell(cell)
        if self.tableView.grouped? and not self.color
          GradientBackgroundView.attach_to_cell(cell, as: "backgroundView")
        end
      end

      def will_display(cell)
        if self.color
          ui_color = self.color.to_color
          if self.tableView.grouped?
            cell.backgroundColor = ui_color
          else
            cell.subviews_recursive_each do |subview|
              subview.backgroundColor = ui_color
            end
          end
        else
          # means we have a gradient top -> bottom
          cell.backgroundView.colors = [self.top.to_color, self.bottom.to_color]
          cell.setPosition(self.row.position_type)
          cell.subviews_recursive_each do |subview|
            subview.backgroundColor = UIColor.clearColor
          end
        end
      end
    end
  end
end