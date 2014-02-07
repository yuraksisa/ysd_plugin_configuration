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
      #
      def render_variable_input_text(variable_name, label, maxlength, size)

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}"/>
              </div>
         EDITOR

      end

      #
      # Render a textarea for editing a variable
      #
      # @param [String] The configuration variable name
      # @param [String] The label
      #
      def render_variable_textarea(variable_name, label)

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable" rows="5" data-autosubmit="true">#{value}</textarea>
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
      #
      def render_variable_input_text_autosubmit(variable_name, label, maxlength, size)

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="/variables" method="POST" 
                 data-remote="ajax" data-remote-method="PUT">
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol" maxlength="#{maxlength}" size="#{size}" 
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
      #
      def render_variable_textarea_autosubmit(variable_name, label)

         value = SystemConfiguration::Variable.get_value(variable_name,'')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="/variables" method="PUT" 
                 data-remote="ajax" data-remote-method="PUT">
              <div class="formrow">
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable" rows="5" data-autosubmit="true">#{value}</textarea>
              </div>
              <input type="submit">Submit</input>
           </form>
         EDITOR

      end

  	end
  end
end