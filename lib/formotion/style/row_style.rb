module Formotion
  module RowStyle
    ROW_STYLES = Formotion::RowStyle.constants(false).select { |constant_name| constant_name =~ /Style$/ }

    class << self
      def for(string_or_sym)
        type = string_or_sym

        if type.is_a?(Symbol) or type.is_a? String
          string = "#{type.to_s.downcase}_style".camelize
          if not const_defined? string
            raise Formotion::InvalidClassError, "Invalid RowType value #{string_or_sym}. Create a class called #{string}"
          end
          Formotion::RowStyle.const_get(string)
        else
          raise Formotion::InvalidClassError, "Attempted row type #{type.inspect} is not a valid RowType."
        end
      end
    end
  end
end