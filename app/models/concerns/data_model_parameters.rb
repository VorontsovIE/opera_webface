require 'active_support/concern'

module DataModelParameters
  extend ActiveSupport::Concern
  module ClassMethods
    def add_data_model_task_param(param_name, background_attribute_name)
      class_eval do
        attr_reader param_name

        add_task_permitted_param("#{param_name}_attributes" => [:data_model, :matrix, :effective_count, :pseudocount])
        define_method "#{param_name}_attributes=" do |value|
          instance_variable_set("@#{param_name}", DataModel.new({background: background_attribute_name.to_proc.call(self) }.merge value))
        end

        add_task_submission_param(param_name) do |t|
          begin
            t.send(param_name).attributes
          rescue Bioinform::Error => e
            raise SubmissionParameters::Error, e.message
          end
        end
      end
    end

  end
end