module Sorcery
  module Model
    module Adapters
      module Couchbase
        extend ActiveSupport::Concern

        included do
          include Sorcery::Model
        end

        def increment(attr)
          val = self.send "#{attr}"
          val += 1
          self.send "#{attr}=", val
        end

        def save!(options = {})
          save!(options)
        end


        def update_single_attribute(name, value)
            update_many_attributes(name => value)
        end

        def update_many_attributes(attrs)
          attrs.each do |name,value|
              write_attribute(name,value)
          end
        end

        module ClassMethods

          def find_by_credentials(credentials)
            @sorcery_config.username_attribute_names.each do |attribute|
              @user = send("by_#{attribute}",:key => credentials[0]).first
              break if @user
            end
            @user
          end

          def find_by_id(id)
            by_id(id)
          end

          def find_by_activation_token(token)
            by_activation_token(:key => token).first
          end

          def transaction(&blk)
            tap(&blk)
          end

          def find_by_sorcery_token(token_attr_name, token)
            send("by_#{token_attr_name}",:key => token).first
          end
        end
      end
    end
  end
end
