class Object
  # Creates an alias for :method with the form
  # old_#{method}
  # Instance evals the block.
  def swizzle(method, &block)
    self.class.send(:alias_method, "old_#{method.to_s}".to_sym, method)
    self.instance_eval &block
  end

  def to_archived_data
    NSKeyedArchiver.archivedDataWithRootObject(self)
  end

  private
  def const_int_get(base, value)
    return value if value.is_a? Integer
    value = value.to_s.camelize
    Kernel.const_get("#{base}#{value}")
  end

  # Looks like RubyMotion adds UIKit constants
  # at compile time. If you don't use these
  # directly in your code, they don't get added
  # to Kernel and const_int_get crashes.
  def load_constants_hack
    [UITextAutocapitalizationTypeNone, UITextAutocapitalizationTypeWords,
      UITextAutocapitalizationTypeSentences,UITextAutocapitalizationTypeAllCharacters,
      UITextAutocorrectionTypeNo, UITextAutocorrectionTypeYes, UITextAutocorrectionTypeDefault,
      UIReturnKeyDefault, UIReturnKeyGo, UIReturnKeyGoogle, UIReturnKeyJoin,
      UIReturnKeyNext, UIReturnKeyRoute, UIReturnKeySearch, UIReturnKeySend,
      UIReturnKeyYahoo, UIReturnKeyDone, UIReturnKeyEmergencyCall,
      UITextFieldViewModeNever, UITextFieldViewModeAlways, UITextFieldViewModeWhileEditing,
      UITextFieldViewModeUnlessEditing, NSDateFormatterShortStyle, NSDateFormatterMediumStyle,
      NSDateFormatterLongStyle, NSDateFormatterFullStyle,
      UITableViewCellSelectionStyleBlue, UITableViewCellSelectionStyleGray, UITableViewCellSelectionStyleNone
    ]
  end
end

class NSData
  def unarchive
    NSKeyedUnarchiver.unarchiveObjectWithData(self)
  end
end
