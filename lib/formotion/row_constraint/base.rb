module Formotion
  module RowConstraint
    class Base < Formotion::Base

      class << self
        # EX apply_to :visible?, :enabled?
        def apply_to(*args)
          @apply_to = args
        end
      end

      attr_accessor :row
      attr_reader :form, :tableView

      PROPERTIES = []

      def form
        self.row.form
      end

      def tableView
        self.row.form.table
      end

      # Is this constraint applied to the calling function;
      # set using the `.apply_to` method in your subclass definition
      def applied_to?(function)
        self.class.instance_variable_get("@apply_to").member? function
      end

      # Override in RowConstraint::Base subclass
      # Return true for the constraint to be applied
      def apply(params = nil)
        params || false
      end

      # Override in RowConstraint::Base subclass
      # Create any KVO observers you need
      def create_observers
      end
    end
  end
end