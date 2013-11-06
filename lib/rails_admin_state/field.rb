require 'builder'

module RailsAdmin
  module Config
    module Fields
      module Types
        class State < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          include RailsAdmin::Engine.routes.url_helpers


          register_instance_option :help do
            ''
          end

          register_instance_option :render do
            @state_machine_options = ::RailsAdminState::Configuration.new @abstract_model
            state_string = bindings[:object].send(name)
            state_class = @state_machine_options.state(state_string)
            state_instance = bindings[:object].class.state_machines[name.to_sym].states[state_string.to_sym]
            output_arr = [
              '<div class="label ' + state_class + '">' + state_instance.human_name + '</div>',
              '<div style="height: 10px;"></div>'
            ]

            unless bindings[:object].new_record?
              events = bindings[:object].class.state_machines[name.to_sym].events
              bindings[:object].send("#{name}_events".to_sym).each do |event|
                event_class = @state_machine_options.event(event)
                output_arr << bindings[:view].link_to(
                  events[event].human_name,
                  state_path(model_name: @abstract_model, id: bindings[:object].id, event: event, attr: name),
                  method: :post,
                  class: "btn #{event_class}",
                  style: 'margin-bottom: 5px;'
                )
              end
            end
            ('<div style="white-space: normal;">' + output_arr.join(' ') + '</div>').html_safe
          end


          register_instance_option :pretty_value do
            @state_machine_options = ::RailsAdminState::Configuration.new @abstract_model
            state_string = bindings[:object].send(name)
            state_class = @state_machine_options.state(state_string)
            state_instance = bindings[:object].class.state_machines[name.to_sym].states[state_string.to_sym]
            "<div style='white-space: normal;'><div class='label #{state_class}'>#{state_instance.human_name}</div></div>".html_safe
          end

          register_instance_option :export_value do
            value.inspect
          end

          register_instance_option :multiple? do
            false
          end
        end
      end
    end
  end
end
