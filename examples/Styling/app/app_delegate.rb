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
          title: "All Red",
          type: :string,
          value: "Red Everything",
          style: {
            font_color: "red"
          }
        }, {
          title: "Red Title",
          type: :text,
          value: "Purple value",
          style: {
            font_color: {
              title: "red",
              value: "purple"
            }
          }
        }, {
          title: "Success!",
          type: :string,
          subtitle: "It worked",
          value: "This is normal",
          style: {
            font_color: {
              title: "09A41D",
              subtitle: "09A41D"
            }
          }
        }, {
          title: "Blue on Gradient",
          type: :string,
          value: "I'm blue",
          style: {
            background_color: {
              top: "ffffff",
              bottom: "dddddd"
            },
            font_color: {
              value: "0088cc"
            }
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
          subtitle: "Tap me",
          type: :string,
          style: {
            selection_color: {
              top: "green",
              bottom: "purple",
              font_color: "red"
            }
          }
        }, {
          title: "Square",
          subtitle: "A subtle touch",
          type: :string,
          style: {
            background_color: {
              top: "ffffff",
              bottom: "dddddd"
            },
            selection_color: {
              top: "eeeeee",
              bottom: "dddddd",
              font_color: "none"
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
