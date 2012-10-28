module Formotion
  module RowConstraint
    ROW_CONSTRAINTS = Formotion::RowConstraint.constants(false).select { |constant_name| constant_name =~ /Constraint$/ }

    class << self
      def for(string_or_sym)
        type = string_or_sym

        if type.is_a?(Symbol) or type.is_a? String
          string = "#{type.to_s.downcase}Constraint".camelize
          if not const_defined? string
            raise Formotion::InvalidClassError, "Invalid RowConstraint value #{string_or_sym}. Create a class called #{string}"
          end
          Formotion::RowConstraint.const_get(string)
        else
          raise Formotion::InvalidClassError, "Attempted row type #{type.inspect} is not a valid RowConstraint."
        end
      end
    end
  end
end