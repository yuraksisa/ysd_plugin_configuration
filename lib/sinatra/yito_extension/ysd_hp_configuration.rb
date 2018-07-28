module Sinatra
  module YitoExtension
    #
    # Configuration helper
    #
  	module ConfigurationHelper

      #
      # Variable photo uploader
      #
      # Options:
      #
      #   photo_album: The photo album id
      #   photo_id: The photo id
      #
      def render_variable_photo_uploader(variable_name)
        if variable = SystemConfiguration::Variable.get(variable_name)
          options = {max_size: 1024*1024,
                     accept: 'image/jpeg,image/gif,image/png,image/jpeg',
                     photo_width: 0,
                     photo_height: 0}
          if variable.value and !variable.value.empty? and !(variable.value == '.')
            photo_id = variable.value.split('/').last
            if photo = Media::Photo.get(photo_id)
              options.store(:photo_album, photo.album.id)
              options.store(:photo_id, photo.id)
            else
              album = Media::Album.first_or_create(name: 'resources')
              options.store(:photo_album, album.id)
            end
          else
            album = Media::Album.first_or_create(name: 'resources')
            options.store(:photo_album, album.id)
          end
          partial :variable_photo, locals: options.merge(variable_name: variable_name, variable_value: variable.value,
                                                         id: variable_name.gsub('.','_') )
        end
      end

      #
      # Render an input text for editing a variable
      #
      # @param [String] variable name
      # @param [String] label
      # @param [Number] maxlength
      # @param [Number] size
      # @param [String] class name
      #
      def render_variable_input_text(variable_name, label, maxlength, size, class_name='', inline=false)

        value = SystemConfiguration::Variable.get_value(variable_name,'')

        editor = ''
        editor << '<div class="formrow">' unless inline
        editor << <<-EDITOR
                <label for="#{variable_name}" class="fieldtitle">#{label}</label>
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}"/>
        EDITOR
        editor << '</div>' unless inline

        return editor

      end

      #
      # Render a variable as boolean checkbox
      #
      # @param [String] variable name
      # @param [String] label
      # @param [String] class name
      #
      def render_variable_checkbox_boolean(variable_name, label, class_name='', inline=false)

        value = SystemConfiguration::Variable.get_value(variable_name, 'false').to_bool

        is_checked = value ? "checked=\"true\"" : ""

        editor = ''
        editor << '<div class="formrow">' unless inline
        editor << <<-EDITOR
              <div class="formrow">         
                <input type="hidden" name="#{variable_name}" id="#{variable_name}" value="false"/>
                <input type="checkbox" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol variable #{class_name}" value="true" style="display:inline; width:auto" #{is_checked}/>
                <label for="#{variable_name}" class="fieldtitle" style="display:inline">#{label}</label>
              </div>
        EDITOR
        editor << '</div>' unless inline

        return editor

      end

      #
      # Render a select
      #
      #
      def render_variable_select(variable_name, label, values, class_name='', inline=false)

        value = SystemConfiguration::Variable.get_value(variable_name,'')

        options = ""

        if values.is_a?(Hash)
          values.each do |option_id, option_value|
            if value.to_sym == option_id.to_sym
              options << "<option value=\"#{option_id}\" selected=\"selected\">#{option_value}</option>"
            else
              options << "<option value=\"#{option_id}\">#{option_value}</option>"
            end
          end
        elsif values.is_a?(Array)
          values.each do |option_value|
            if value.to_s == option_value.to_s
              options << "<option value=\"#{option_value}\" selected=\"selected\">#{option_value}</option>"
            else
              options << "<option value=\"#{option_value}\">#{option_value}</option>"
            end
          end
        end

        editor = ''
        editor << '<div class="formrow bottom-space">' unless inline
        editor << "<label for=\"#{variable_name}\" class=\"fieldtitle\">#{label}</label>" if !label.nil? and !label.empty?

        editor << <<-EDITOR
                <select name="#{variable_name}" id="#{variable_name}" 
                  class="#{inline ? '' : 'fieldcontrol'} variable #{class_name}">
                  #{options}
                </select>
        EDITOR

        editor << '</div>' unless inline

        return editor

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