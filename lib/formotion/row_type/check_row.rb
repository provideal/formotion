module Formotion
  module RowType
    class CheckRow < Base
      include BW::KVO

      def update_cell_value(cell)
        if row.value 
          cell.accessoryView = cell.editingAccessoryView = UIImageView.alloc.initWithImage(UIImage.viewImage('checkmark'))
        else
          cell.accessoryView = cell.editingAccessoryView = UIView.alloc.initWithFrame(CGRectZero)
        end
        # cell.accessoryType = cell.editingAccessoryType = row.value ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
      end

      # This is actually called whenever again cell is checked/unchecked
      # in the UITableViewDelegate callbacks. So (for now) don't
      # instantiate long-lived objects in them.
      # Maybe that logic should be moved elsewhere?
      def build_cell(cell)
        update_cell_value(cell)
        observe(self.row, "value") do |old_value, new_value|
          update_cell_value(cell)
        end
        nil
      end

      def on_select(tableView, tableViewDelegate)
        # special case (stupid hack: fix this)
        f = row.form
        check = Proc.new{|r| r.key == 0 && r.title.start_with?('All')}

        if check.call(row)
          row.value = !row.value
          f.sections.each do |s|
            s.rows.each do |r|
              r.value = row.value if r.type == :check
            end
          end
          return
        end 

        # original:
        if !row.editable?
          return
        end
        if row.section.select_one and !row.value
          row.section.rows.each do |other_row|
            other_row.value = (other_row == row)
          end
        elsif !row.section.select_one
          row.value = !row.value
        end

        # the craziness continues...
        unless row.value
          f.send(:each_row) do |r|
            r.value = nil if check.call(r)
          end
        end
      end

    end
  end
end