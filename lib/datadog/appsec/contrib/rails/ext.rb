# frozen_string_literal: true

module Datadog
  module AppSec
    module Contrib
      module Rails
        # Rack integration constants
        module Ext
          APP = 'rails'
          ENV_ENABLED = 'DD_TRACE_RAILS_ENABLED'
        end
      end
    end
  end
end
