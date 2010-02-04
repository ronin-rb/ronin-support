require 'yard'

module Ronin
  module Yard
    module Extensions
      protected

      def effected_namespace
        if statement.type == :command_call
          context = statement.jump(:var_ref)

          unless context.source == 'self'
            return ensure_loaded!(
              Registry.resolve(namespace,context.source)
            )
          end
        end

        return namespace
      end

    end
  end
end
