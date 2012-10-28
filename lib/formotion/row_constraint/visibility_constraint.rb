module Formotion
  module RowConstraint
    class VisibilityConstraint < Base
      include BW::KVO

      # Hides a row
      # EX when the value of row :user_name is nil,
      # hide this row

      # type: visible
      # visible: true,
      # on_key: :user_name,
      # when_value: :nil

      # when_value: :not_nil
      # when_value: "3"

      apply_to :visible?

      PROPERTIES = [
        # Do we set this row visible or invisible when applied.
        # Thus if :set == :visible, then by default the row is invisible.
        # VALUES :visible, :invisible
        # DEFAULT :visible
        :set,
        # The row key do we use
        :on_key,
        # A value (or values) which trigger this constraint
        # Special values are :nil, :not_nil, :empty, :not_empty
        # EX ["Password", "Secret"]
        # DEFAULT :empty
        :when_value,
        # Is this constraint triggered when ANY of the values
        # are true or are all of them required?
        # DEFAULT true
        :on_any,
      ].each { |prop|
        attr_accessor prop
      }

      attr_accessor :last_trigger_value

      def create_observers
        observe(self.target_row, "value") do |old_value, new_value|
          if self.last_trigger_value != self.trigger?(self.target_row.value)

            self.tableView.beginUpdates
            if self.apply
              self.tableView.insertRowsAtIndexPaths([self.row.index_path], withRowAnimation:UITableViewRowAnimationTop)
            else
              self.tableView.deleteRowsAtIndexPaths([self.row.index_path], withRowAnimation:UITableViewRowAnimationTop)
            end
            self.tableView.endUpdates

          end
        end
      end

      def target_row
        self.form.row_for_key(self.on_key)
      end

      def apply(params = nil)
        rendered = self.row.form.render

        triggering = trigger?(rendered[self.on_key])
        self.last_trigger_value = triggering

        (self.set == :visible) ? triggering : !triggering
      end

      def trigger?(value)
        triggering = self.when_value.collect { |trigger_value|
          case trigger_value
          when :nil
            value.nil?
          when :not_nil
            !value.nil?
          when :empty
            value.to_s.empty?
          when :not_empty
            !value.to_s.empty?
          else
            value == trigger_value
          end
        }

        self.on_any ? triggering.any? : triggering.all?
      end

      #########################
      #  Getters/setters
      def when_value=(when_value)
        case when_value
        when Array
          @when_value = when_value
        else
          @when_value = [when_value]
        end
      end

      def set
        @set ||= :visible
      end

      def when_value
        @when_value ||= [:not_empty]
      end

      def on_any
        @on_any ||= true
      end
    end
  end
end