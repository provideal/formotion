class AppDelegate

  attr_accessor :view_controller, :form
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @form = Formotion::Form.new({
      sections: [{
        title: "Solid Color",
        rows: [{
          title: "Red",
          type: :string,
          style: {
            background_color: "ff0000"
          }
        }, {
          title: "Blue",
          type: :string,
          style: {
            background_color: "blue"
          }
        }]
      }, {
        title: "Gradient",
        rows: [{
          title: "White To Off White",
          type: :string,
          style: {
            background_color: {
              top: "ffffff",
              bottom: "f0f0f0"
            }
          }
        }, {
          title: "White To Blue",
          type: :string,
          style: {
            background_color: {
              top: "ffffff",
              bottom: "blue"
            }
          }
        }]
      }, {
        title: "Font Color",
        rows: [{
          title: "White on Red",
          type: :string,
          style: {
            background_color: "red",
            font_color: "white"
          }
        }, {
          title: "Blue on Gradient",
          type: :string,
          style: {
            background_color: {
              top: "ffffff",
              bottom: "dddddd"
            },
            font_color: "0088cc"
          }
        }]
      }, {
        title: "Selection Color",
        rows: [{
          title: "Gray",
          type: :string,
          style: {
            background_color: {
              top: "ffffff",
              bottom: "dddddd"
            },
            font_color: "333333",
            selection_color: "gray"
          }
        }, {
          title: "Red",
          type: :string,
          style: {
            selection_color: "red"
          }
        }, {
          title: "Green to Purple",
          type: :string,
          style: {
            selection_color: {
              top: "green",
              bottom: "purple"
            }
          }
        }, {
          title: "Square",
          type: :string,
          style: {
            background_color: {
              top: "ffffff",
              bottom: "dddddd"
            },
            selection_color: {
              top: "eeeeee",
              bottom: "dddddd"
            }
          }
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
