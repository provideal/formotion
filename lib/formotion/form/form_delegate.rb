module Formotion
  class Form < Formotion::Base
    attr_reader :table
    attr_reader :controller
    attr_reader :active_row

    def active_row=(row)
      @active_row = row

      if @active_row && @table
        index_path = NSIndexPath.indexPathForRow(@active_row.index, inSection:@active_row.section.index)
        @table.scrollToRowAtIndexPath(index_path, atScrollPosition:UITableViewScrollPositionMiddle,  animated:true)
      end
    end

    ####################
    # Table Methods
    def controller=(controller)
      @controller = controller
      @controller.title = self.title
      self.table = controller.respond_to?(:table_view) ? controller.table_view : controller.tableView
    end

    def table=(table_view)
      @table = table_view

      @table.delegate = self
      @table.dataSource = self
      reload_data
    end

    def reload_data
      previous_row, next_row = nil

      last_row = self.visible_sections[-1] && self.visible_sections[-1].visible_rows[-1]
      if last_row
        last_row.return_key ||= UIReturnKeyDone
      end

      @table.reloadData
    end

    # UITableViewDataSource Methods
    def numberOfSectionsInTableView(tableView)
      self.visible_sections.count
    end

    def tableView(tableView, numberOfRowsInSection: section)
      self.visible_sections[section].visible_rows.count
    end

    def tableView(tableView, titleForHeaderInSection:section)
      section = self.visible_sections[section].title
    end

    def tableView(tableView, titleForFooterInSection:section)
      self.visible_sections[section].footer
    end

    def tableView(tableView, cellForRowAtIndexPath:indexPath)
      row = visible_row_for_index_path(indexPath)
      reuseIdentifier = row.reuse_identifier

      cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
        row.make_cell
      end

      row.update_cell(cell)

      cell
    end

    def tableView(tableView, heightForRowAtIndexPath: indexPath)
      row = visible_row_for_index_path(indexPath)
      row.row_height || tableView.rowHeight
    end

    def tableView(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
      row = visible_row_for_index_path(indexPath)
      case editingStyle
      when UITableViewCellEditingStyleInsert
        row.object.on_insert(tableView, self)
      when UITableViewCellEditingStyleDelete
        row.object.on_delete(tableView, self)
      end
    end


    # UITableViewDelegate Methods
    def tableView(tableView, didSelectRowAtIndexPath:indexPath)
      tableView.deselectRowAtIndexPath(indexPath, animated:true)
      row = visible_row_for_index_path(indexPath)
      row.object.on_select(tableView, self)
    end

    def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
      row = visible_row_for_index_path(indexPath)
      row.object.cellEditingStyle
    end


    def tableView(tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath)
      row = visible_row_for_index_path(indexPath)
      row.object.indentWhileEditing?
    end
  end
end