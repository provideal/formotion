class AppDelegate

  attr_accessor :view_controller, :form
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @form = Formotion::Form.new({
      sections: [{
        title: "Visibility - Default",
        rows: [{
          title: "Type Anything",
          key: :visibility_default,
          type: :string
        }, {
          title: "Hidden!",
          type: :static,
          constraints: [{
            type: :visibility,
            on_key: :visibility_default
          }]
        }]
      }, {
        title: "Visibility - when_value",
        rows: [{
          title: "Type 'SECRET'",
          key: :visibility_when_value,
          type: :string
        }, {
          title: "Hello!",
          type: :static,
          constraints: [{
            type: :visibility,
            on_key: :visibility_when_value,
            when_value: "SECRET"
          }]
        }]
      }, {
        title: "Visibility - picker",
        rows: [{
          title: "Pick 'Show'",
          key: :visibility_picker,
          type: :picker,
          items: ["Hide", "Show"],
          value: "Hide"
        }, {
          title: "Cool!",
          type: :static,
          constraints: [{
            type: :visibility,
            on_key: :visibility_picker,
            when_value: "Show"
          }]
        }]
      }, {
        title: "Visibility - invisible",
        rows: [{
          title: "Type 'HIDE'",
          key: :invisible_when_value,
          type: :string
        }, {
          title: "Hello!",
          type: :static,
          constraints: [{
            type: :visibility,
            set: :invisibile,
            on_key: :invisible_when_value,
            when_value: "HIDE"
          }]
        }]
      }]
    })

    @view_controller = Formotion::FormController.alloc.initWithForm(@form)
    @view_controller.form.on_submit do |form|
        p @view_controller.form.render
      end

    @window.rootViewController = @view_controller
    @window.makeKeyAndVisible
    true
  end
end
