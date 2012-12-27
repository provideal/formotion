#################
#
# Formotion::RowCellBuilder
# RowCellBuilder handles taking Formotion::Rows
# and configuring UITableViewCells based on their properties.
#
#################
module Formotion
  class RowCellBuilder

    # PARAMS row.is_a? Formotion::Row
    # RETURNS [cell configured to that row, a UITextField for that row if applicable or nil]
    def self.make_cell(row)
      cell, text_field = nil

      cell = ListCell.alloc.initWithStyle(row.object.cell_style, reuseIdentifier:row.reuse_identifier)

      cell.accessoryType = cell.editingAccessoryType = UITableViewCellAccessoryNone
      cell.textLabel.text = row.title
      cell.detailTextLabel.text = row.subtitle

      edit_field = row.object.build_cell(cell)
      
      if edit_field
        edit_field.textInputTraits.setValue('#94c11f'.to_color.colorWithAlphaComponent(0.7), forKey:'insertionPointColor')
        edit_field.textInputTraits.setValue('#94c11f'.to_color.colorWithAlphaComponent(0.2), forKey:'selectionHighlightColor') 
        edit_field.textInputTraits.setValue('#94c11f'.to_color, forKey:'selectionBarColor') 
        edit_field.textInputTraits.setValue(UIImage.imageNamed('selection_text.png'), forKey:'selectionDragDotImage') 
        edit_field.font = UIFont.fontWithName('Exo', size: 15)
        edit_field.textColor = '#444444'.to_color
      end

      [cell, edit_field]
    end

  end
end