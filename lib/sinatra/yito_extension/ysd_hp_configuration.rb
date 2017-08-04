module Sinatra
  module YitoExtension
    #
    # Configuration helper
    #
  	module ConfigurationHelper

      #
      # Render an input text for editing a variable
      #
      # @param [String] variable name
      # @param [String] label
      # @param [Number] maxlength
      # @param [Number] size
      # @param [String] class name
      #
      def render_variable_input_text(variable_name, label, maxlength, size, class_name='')

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}"/>
              </div>
         EDITOR

      end

      #
      # Render a variable as boolean checkbox
      #
      # @param [String] variable name
      # @param [String] label
      # @param [String] class name
      #
      def render_variable_checkbox_boolean(variable_name, label, class_name='')
         
         value = SystemConfiguration::Variable.get_value(variable_name, 'false').to_bool

         is_checked = value ? "checked=\"true\"" : ""

         editor = <<-EDITOR
              <div class="formrow">         
                <input type="hidden" name="#{variable_name}" id="#{variable_name}" value="false"/>
                <input type="checkbox" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" value="true" style="display:inline; width:auto" #{is_checked}/>
                <label for="#{variable_name}" class="fieldtitle" style="display:inline">#{label}</label>
              </div>        
         EDITOR
         

      end

      #
      # Render a select
      #
      #
      def render_variable_select(variable_name, label, values, class_name='')

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         options = ""

         if values and values.respond_to?(:each)
            values.each do |option_id, option_value| 
              options << (value.to_sym == option_id.to_sym ?
                 "<option value=\"#{option_id}\" selected=\"selected\">#{option_value}</option>" :
                 "<option value=\"#{option_id}\">#{option_value}</option>" 
                 )
            end
         end

         editor = <<-EDITOR
              <div class="formrow bottom-space">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <select name="#{variable_name}" id="#{variable_name}" 
                  class="fieldcontrol variable #{class_name}">
                  #{options}
                </select>
              </div>
         EDITOR

      end

      #
      # Render a textarea for editing a variable
      #
      # @param [String] The configuration variable name
      # @param [String] The label
      # @param [String] class name      
      #
      def render_variable_textarea(variable_name, label, class_name='')

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" rows="5">#{value}</textarea>
              </div>
         EDITOR

      end
      
      #
      # Render an input text for editing a variable with autosubmit
      #
      # @param [String] variable name
      # @param [String] label
      # @param [Number] maxlength
      # @param [Number] size
      # @param [String] class name
      #
      def render_variable_input_text_autosubmit(variable_name, label, maxlength, size, class_name='')

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="/api/variables" method="POST" 
                 data-remote="ajax" data-remote-method="PUT">
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}" data-autosubmit="true"/>
              </div>
              <input type="submit">Submit</input>
           </form>
         EDITOR

      end

      #
      # Render a textarea for editing a variable with autosubmit
      #
      # @param [String] The configuration variable name
      # @param [String] The label
      # @param [String] class name      
      #
      def render_variable_textarea_autosubmit(variable_name, label, class_name='')

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="/api/variables" method="PUT" 
                 data-remote="ajax" data-remote-method="PUT">
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" rows="5" data-autosubmit="true">#{value}</textarea>
              </div>
              <input type="submit">Submit</input>
           </form>
         EDITOR

      end

      # --------------------------------- Secure variable -----------------------------------------------------

      #
      # Render an input text for editing a variable
      #
      # @param [String] variable name
      # @param [String] label
      # @param [Number] maxlength
      # @param [Number] size
      # @param [String] class name
      #
      def render_secure_variable_input_text(variable_name, label, maxlength, size, class_name='')

         value = SystemConfiguration::SecureVariable.get_value(variable_name,'')

         editor = <<-EDITOR 
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}"/>
              </div>
         EDITOR

      end

      #
      # Render a variable as boolean checkbox
      #
      # @param [String] variable name
      # @param [String] label
      # @param [String] class name
      #
      def render_secure_variable_checkbox_boolean(variable_name, label, class_name='')
         
         value = SystemConfiguration::SecureVariable.get_value(variable_name, 'false').to_bool

         is_checked = value ? "checked=\"true\"" : ""

         editor = <<-EDITOR
              <div class="formrow">         
                <input type="hidden" name="#{variable_name}" id="#{variable_name}" value="false"/>
                <input type="checkbox" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" value="true" style="display:inline; width:auto" #{is_checked}/>
                <label for="#{variable_name}" class="fieldtitle" style="display:inline">#{label}</label>
              </div>        
         EDITOR
         

      end

      #
      # Render a select
      #
      #
      def render_secure_variable_select(variable_name, label, values, class_name='')

         value = SystemConfiguration::SecureVariable.get_value(variable_name,'')

         options = ""

         if values and values.respond_to?(:each)
            values.each do |option_id, option_value| 
              options << (value.to_sym == option_id.to_sym ?
                 "<option value=\"#{option_id}\" selected=\"selected\">#{option_value}</option>" :
                 "<option value=\"#{option_id}\">#{option_value}</option>" 
                 )
            end
         end

         editor = <<-EDITOR
              <div class="formrow bottom-space">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <select name="#{variable_name}" id="#{variable_name}" 
                  class="fieldcontrol variable #{class_name}">
                  #{options}
                </select>
              </div>
         EDITOR

      end

      #
      # Render a textarea for editing a variable
      #
      # @param [String] The configuration variable name
      # @param [String] The label
      # @param [String] class name      
      #
      def render_secure_variable_textarea(variable_name, label, class_name='')

         value = SystemConfiguration::SecureVariable.get_value(variable_name,'')

         editor = <<-EDITOR 
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" rows="5">#{value}</textarea>
              </div>
         EDITOR

      end
      
      #
      # Render an input text for editing a variable with autosubmit
      #
      # @param [String] variable name
      # @param [String] label
      # @param [Number] maxlength
      # @param [Number] size
      # @param [String] class name
      #
      def render_secure_variable_input_text_autosubmit(variable_name, label, maxlength, size, class_name='')

         value = SystemConfiguration::SecureVariable.get_value(variable_name,'')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="/api/svariables" method="POST" 
                 data-remote="ajax" data-remote-method="PUT">
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}" data-autosubmit="true"/>
              </div>
              <input type="submit">Submit</input>
           </form>
         EDITOR

      end

      #
      # Render a textarea for editing a variable with autosubmit
      #
      # @param [String] The configuration variable name
      # @param [String] The label
      # @param [String] class name      
      #
      def render_secure_variable_textarea_autosubmit(variable_name, label, class_name='')

         value = SystemConfiguration::SecureVariable.get_value(variable_name,'')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="/api/svariables" method="PUT" 
                 data-remote="ajax" data-remote-method="PUT">
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" rows="5" data-autosubmit="true">#{value}</textarea>
              </div>
              <input type="submit">Submit</input>
           </form>
         EDITOR

      end         

  	end
  end
end